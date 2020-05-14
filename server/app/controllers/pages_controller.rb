# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :load_beds

  def dashboard
    render_json(
      covid_cases: cases_data,
      beds: beds_data,
      hospitals: hospitals_data,
      cities: City.cached_for_select,
    )
  end

  private

  def beds_data
    cached_data :beds_data do
      {
        updated_at: Time.zone.now.iso8601,
        intensive_care_unit: bed_json(@beds, 1, 2),
        nursing: bed_json(@beds, 3, 4),
        ventilator: bed_json(@beds.using_ventilator, [1, 3], [2, 4])
      }
    end
  end

  def cases_data
    cached_data :cases_data do
      {
        updated_at: Time.zone.now.iso8601,
        cases: @city.covid_cases.order(created_at: :desc).limit(15).map(&:to_json)
      }
    end
  end

  def hospitals_data
    cached_data :hospitals_data do
      @city.hospitals.includes(:beds).map(&:to_json)
    end
  end

  def bed_json beds, covid_beds, no_covid_beds
    total = busy = 0.0

    covid_beds = beds.where(bed_type: covid_beds)
    no_covid_beds = beds.where(bed_type: no_covid_beds)

    json = {
      covid: {
        total: covid_beds.count,
        busy: covid_beds.busy.count
      },
      no_covid: {
        total: no_covid_beds.count,
        busy: no_covid_beds.busy.count
      }
    }

    total += json[:covid][:total] + json[:no_covid][:total]
    busy += json[:covid][:busy] + json[:no_covid][:busy]

    json.merge(percent: (busy / total * 100).round(1))
  end

  def load_beds
    @hospital = nil
    @city = params[:city].present? ? params[:city] : 'ribeirao-preto'
    @city = City.cached_for(@city)

    return @beds = @city.beds if params[:hospital].blank?

    @hospital = @city.hospitals.find { |hospital| hospital.slug == params[:hospital] }
    @beds = @hospital.beds
  end

  def cached_data name, &block
    Rails.cache.fetch([name, @city.slug, @hospital&.slug], expires_in: rand(10..17).minutes, &block)
  end

end
