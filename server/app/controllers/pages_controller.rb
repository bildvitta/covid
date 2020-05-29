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

  def historical
    data = {}
    names = {
      'Ribeirânia (Hospital São Lucas Ribeirânia)' => 'Hospital São Lucas Ribeirânia',
      'Hospital Santa Casa de Misericórdia de Ribeirão Preto' => 'S. Casa de Misericórdia Rib. Pr'
    }
    
    historical_data.each do |date, values|
      values[:beds].each do |hash|
        params = [I18n.l(date.to_date)] + hash[:intensive_care_unit].values.map(&:values).flatten + hash[:nursing].values.map(&:values).flatten
        name = names[hash[:name]] || hash[:name]

        data.key?(hash[:name]) ? data[name] << params : data[name] = [params]
      end
    end

    ExcelGenerate.new(
      [
        "Data",
        "UTI - Convid - Total", "UTI - Convid - Livre ", "UTI - Convid - Ocupado ", "UTI - Convid - Indisponível",
        "UTI - Normal - Total", "UTI - Normal - Livre ", "UTI - Normal - Ocupado ", "UTI - Normal - Indisponível",
        "UTI - Respirador - Total", "UTI - Respirador - Livre ", "UTI - Respirador - Ocupado ", "UTI - Respirador - Indisponível",
        "Enfermaria - Convid - Total", "Enfermaria - Convid - Livre", "Enfermaria - Convid - Ocupado", "Enfermaria - Convid - Indisponível",
        "Enfermaria - Normal - Total", "Enfermaria - Normal - Livre", "Enfermaria - Normal - Ocupado", "Enfermaria - Normal - Indisponível",
        "Enfermaria - Respirador - Total", "Enfermaria - Respirador - Livre", "Enfermaria - Respirador - Ocupado", "Enfermaria - Respirador - Indisponível"
      ],
      data
    ).generate!("/app/relatorio-leitos-#{Date.today.to_s}")

    render_json({})
  end

  private

  def beds_data
    cached_data :beds_data do
      block = -> (beds) {
        free = busy = unavailable = 0

        beds.each do |bed|
          free += 1 if bed.free?
          busy += 1 if bed.busy?
          unavailable += 1 if bed.unavailable?
        end

        {
          total: free + busy + unavailable,
          free: free,
          busy: busy,
          unavailable: unavailable
        }
      }

      {
        updated_at: @beds.order(updated_at: :desc).first&.updated_at&.iso8601,
        intensive_care_unit: bed_json(@beds.icus, &block),
        nursing: bed_json(@beds.nursings, &block),
        ventilator: bed_json(@beds.using_ventilator, &block)
      }
    end
  end

  def cases_data
    cached_data :cases_data do
      covid_case = @city.covid_cases.order(reference_date: :desc).first || CovidCase.new

      {
        updated_at: covid_case.updated_at&.iso8601,
        cases: covid_case.to_json
      }
    end
  end

  def hospitals_data
    cached_data :hospitals_data do
      @city.hospitals.includes(:beds).map(&:to_json)
    end
  end

  def bed_json details, &block
    covid_beds = []
    normal_beds = []
    ventilators = []

    details.each do |detail|
      covid_beds << detail if detail.covid?
      normal_beds << detail if detail.normal?
      ventilators << detail if detail.using_ventilator
    end

    unless block
      block = -> (bed_details) {
        free = busy = unavailable = 0

        bed_details.each do |detail|
          free += detail.status_free
          busy += detail.status_busy
          unavailable += detail.status_unavailable
        end

        {
          total: free + busy + unavailable,
          free: free,
          busy: busy,
          unavailable: unavailable
        }
      }
    end

    {
      covid: block.(covid_beds),
      normal: block.(normal_beds),
      ventilator: block.(ventilators)
    }
  end

  def historical_data
    cached_data :historical_data do
      (30.days.ago.to_date..1.days.ago.to_date).map do |date|
        covid_cases = @city.covid_cases.find { |covid_case| covid_case.reference_date == date }
        covid_cases ||= CovidCase.new

        data = {
          covid_cases: covid_cases.to_json,
          beds: @city.hospitals.map do |hospital|
            details = hospital.bed_states.to_a.find_by(:date, date)&.details.to_a

            intensive_care_unit = []
            nursing = []

            details.each do |detail|
              detail.icu? ? intensive_care_unit << detail : nursing << detail
            end

            {
              name: hospital.name,
              latitude: hospital.latitude,
              longitude: hospital.longitude,
              intensive_care_unit: bed_json(intensive_care_unit),
              nursing: bed_json(nursing)
            }
          end
        }

        [date.to_time.iso8601, data]
      end.to_h
    end
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
    block.()
    # Rails.cache.fetch([name, @city.slug, @hospital&.slug], expires_in: rand(10..17).minutes, &block)
  end

end
