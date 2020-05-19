# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :load_beds

  def dashboard
    render_json(
      cities: City.cached_for_select,
      beds: beds_data,
      hospitals: hospitals_data,
      covid_cases: cases_data,
      historical: historical_data,
    )
  end

  private

  def beds_data
    cached_data :beds_data do
      beds = @beds.to_a

      block = -> (bed) {
        {
          free: bed.count(&:free?),
          busy: bed.count(&:busy?),
          unavailable: bed.count(&:unavailable?)
        }
      }

      {
        updated_at: Time.zone.now.iso8601,
        intensive_care_unit: bed_json(beds, 1, 2, &block),
        nursing: bed_json(beds, 3, 4, &block),
        ventilator: bed_json(beds.select(&:using_ventilator), Bed.covid_types, Bed.normal_types, &block)
      }
    end
  end

  def cases_data
    cached_data :cases_data do
      {
        updated_at: Time.zone.now.iso8601,
        cases: @city.covid_cases.order(created_at: :desc).first.to_json
      }
    end
  end

  def hospitals_data
    cached_data :hospitals_data do
      @city.hospitals.includes(:beds).map(&:to_json)
    end
  end

  def bed_json details, covid_beds, normal_beds, &block
    covid_beds = normal_beds = ventilators = []

    details.each do |detail|
      covid_beds << detail if detail.bed_type == covid_beds
      normal_beds << detail if detail.bed_type == normal_beds
      ventilators << detail if detail.using_ventilator
    end

    unless block
      block = -> (bed_details) {
        {
          free: bed_details.sum(&:status_free),
          busy: bed_details.sum(&:status_busy),
          unavailable: bed_details.sum(&:status_unavailable)
        }
      }
    end

    {
      covid: block.(covid_beds),
      normal: block.(normal_beds),
      ventilator: block.(ventilators)
    }
  end

  def load_beds
    @hospital = nil
    @city = params[:city].present? ? params[:city] : 'ribeirao-preto'
    @city = City.cached_for(@city)

    return @beds = @city.beds if params[:hospital].blank?

    @hospital = @city.hospitals.find { |hospital| hospital.slug == params[:hospital] }
    @beds = @hospital.beds
  end

  def historical_data
    cached_data :historical_data do
      @city.hospitals.includes(:beds).map(&:to_json)

      (30.days.ago.to_date..Date.today).map do |date|
        covid_cases = @city.covid_cases.find { |covid_case| covid_case.created_at.to_date == date }
        covid_cases ||= CovidCase.new

        data = {
          covid_cases: covid_cases.to_json,
          beds: @city.hospitals.map do |hospital|
            details = hospital.bed_states.to_a.find_by(:date, date)&.details.to_a

            intensive_care_unit = bed_json(details.select { |detail| [1, 2].include?(detail.bed_type) }, 1, 2)
            nursing = bed_json(details.select { |detail| [3, 4].include?(detail.bed_type) }, 3, 4)

            {
              name: hospital.name,
              latitude: hospital.latitude,
              longitude: hospital.longitude,
              intensive_care_unit: intensive_care_unit,
              nursing: nursing
            }
          end
        }

        [date, data]
      end.to_h
    end
  end

  def cached_data name, &block
    Rails.cache.fetch([name, @city.slug, @hospital&.slug], expires_in: rand(10..17).minutes, &block)
  end

end
