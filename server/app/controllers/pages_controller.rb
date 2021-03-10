# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :load_beds

  def dashboard
    render_json(
      cities: City.cached_for_select,
      beds: beds_data,
      hospitals: hospitals_data,
      covid_cases: cases_data,
      historical: historical_data(filter_params[:started_at], filter_params[:finished_at])
    )
  end

  def historical_report
    expires_in = ('03:00'.to_time.next_day - Time.zone.now).seconds

    filename_link = cached_data :historical_xlsx, expires_in: expires_in do
      historical_xlsx
    end

    render_json({ link: filename_link })
  end

  private

  def beds_data
    cached_data :beds_data do
      block = -> (beds) {
        total = free = busy = unavailable = ventilator = 0

        beds.each do |bed|
          free += 1 if bed.free?# && !bed.extra?
          busy += 1 if bed.busy?
          unavailable += 1 if bed.unavailable?
          ventilator += 1 if bed.using_ventilator

          total += 1 unless bed.extra?
        end

        {
          total: total,
          free: free,
          busy: busy,
          unavailable: unavailable,
          ventilator: ventilator
        }
      }

      {
        updated_at: @beds.order(updated_at: :desc).first&.updated_at&.iso8601,
        intensive_care_unit: bed_json(@beds.icus, &block),
        nursing: bed_json(@beds.nursings, &block)
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
      @city.hospitals.joins(:beds).order('beds.updated_at DESC').includes(:beds).map(&:to_json)
    end
  end

  def bed_json details, &block
    covid_beds = []
    normal_beds = []

    details.each do |detail|
      covid_beds << detail if detail.covid?
      normal_beds << detail if detail.normal?
    end

    unless block
      block = -> (bed_details) {
        total = free = busy = unavailable = ventilator = 0

        bed_details.each do |detail|
          free += detail.status_free
          busy += detail.status_busy
          unavailable += detail.status_unavailable
          ventilator += detail.status_free + detail.status_busy + detail.status_unavailable if detail.using_ventilator

          total += detail.status_free + detail.status_busy + detail.status_unavailable unless detail.extra?
        end

        {
          total: total,
          free: free,
          busy: busy,
          unavailable: unavailable,
          ventilator: ventilator
        }
      }
    end

    {
      covid: block.(covid_beds),
      normal: block.(normal_beds)
    }
  end

  def historical_data started_at, finished_at
    started_at ||= 30.days.ago
    finished_at ||= 1.days.ago

    cached_data "historical_data_#{started_at.to_date.to_s}_to_#{finished_at.to_date.to_s}" do
      range_days = started_at.to_date..finished_at.to_date
      hospitals = @city.hospitals.distinct.where(filter_beds).reorder(id: :asc)
      bed_states = BedState.joins(:hospital, :details).where(date: range_days, hospital: hospitals).distinct
      bed_states = bed_states.includes(:details).distinct.map { |bed_state| [[bed_state.date.to_s, bed_state.hospital_id], bed_state.details] }.to_h

      range_days.map do |date|
        covid_cases = @city.covid_cases.find { |covid_case| covid_case.reference_date == date }
        covid_cases ||= CovidCase.new

        data = {
          covid_cases: covid_cases.to_json,
          beds: hospitals.map do |hospital|
            details = bed_states[[date.to_s, hospital.id]].to_a

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

    @beds = @city.beds.joins(:hospital).where(filter_beds).distinct.reorder(id: :desc)
  end

  def cached_data name, expires_in: rand(10..17).minutes, &block
    Rails.cache.fetch([name, @city.slug, filter_params], expires_in: expires_in, &block)
  end

  def historical_xlsx
    data = {}
    names = {
      'Ribeirânia (Hospital São Lucas Ribeirânia)' => 'Hospital São Lucas Ribeirânia',
      'Hospital Santa Casa de Misericórdia de Ribeirão Preto' => 'S. Casa de Misericórdia Rib. Pr',
      'Hospital das Clínicas Unidade de Emergência' => 'H. das Clínicas Uni. de Emer.'
    }

    historical_data(
      filter_params[:started_at] || Date.new(2020, 5, 21), filter_params[:finished_at]
    ).each do |date, values|
      values[:beds].each do |hash|
        params = [I18n.l(date.to_date)] + hash[:intensive_care_unit].values.map(&:values).flatten + hash[:nursing].values.map(&:values).flatten
        name = names[hash[:name]] || hash[:name]
        name = name.first(31)

        data.key?(name) ? data[name] << params : data[name] = [params]
      end
    end

    filename = "relatorio-leitos-#{@city.slug}#{'-' + @hospital.slug if @hospital}.xlsx"
    path = Rails.root.join('public/reports/' + filename).to_s

    ExcelGenerate.new(
      [
        'Data',
        'UTI - Convid - Total', 'UTI - Convid - Livre ', 'UTI - Convid - Ocupado ', 'UTI - Convid - Indisponível', 'UTI - Convid - Respirador',
        'UTI - Normal - Total', 'UTI - Normal - Livre ', 'UTI - Normal - Ocupado ', 'UTI - Normal - Indisponível', 'UTI - Normal - Respirador',
        'Enfermaria - Convid - Total', 'Enfermaria - Convid - Livre', 'Enfermaria - Convid - Ocupado', 'Enfermaria - Convid - Indisponível', 'Enfermaria - Normal - Respirador',
        'Enfermaria - Normal - Total', 'Enfermaria - Normal - Livre', 'Enfermaria - Normal - Ocupado', 'Enfermaria - Normal - Indisponível', 'Enfermaria - Normal - Respirador'
      ],
      data
    ).generate!(path)

    "#{request.protocol}#{request.host_with_port}/reports/#{filename}"
  end

  def filter_params
    return @filter_params if @filter_params

    @filter_params = {}

    where_limitation = {
      slug: Hospital.hospital_slugs,
      hospital_type: Hospital::TYPE_ENUM.keys
    }

    # Intersects with possible values, so it won't cache wrong values
    where_limitation.each do |key, values|
      result = (params[:hospital].to_s.split(',') & values).sort
      (@filter_params[:hospitals] ||= {})[key] = result if result.any?
    end

    valid_date if params[:started_at] || params[:finished_at]

    @filter_params
  end

  def valid_date
    [:started_at, :finished_at].each do |date|
      filter_params[date] = begin
        params[date].to_date
      rescue
        return render_json({error: 'Invalid Date'}, 401)
      end
    end

    if filter_params[:started_at] >= filter_params[:finished_at]
      return render_json({error: 'Invalid Date Range'}, 401)
    end

    filter_params[:finished_at] = Date.today if filter_params[:finished_at] > Date.today
  end

  def filter_beds
    return @filter_beds if @filter_beds

    hospital_table = Hospital.arel_table

    # Creating arel nodes to it
    filter_params[:hospitals].to_h.each do |key, value|
      statement = hospital_table[key].in(value)
      @filter_beds = @filter_beds.nil? ? statement : @filter_beds.or(statement)
    end

    @filter_beds
  end
end
