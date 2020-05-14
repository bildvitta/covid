# frozen_string_literal: true

class PagesController < ApplicationController
  include ActionView::Helpers::DateHelper

  def home
    beds = get_beds

    render_json(
      beds: {
        updated_at: distance_of_time_in_words(Time.zone.now, Time.zone.now + 30.minutes),
        intensive_care_unit: bed_json(beds, 1, 2),
        nursing: bed_json(beds, 3, 4),
        ventilator: bed_json(beds.using_ventilator, [1, 3], [2, 4])
      },
      cases: {
        updated_at: distance_of_time_in_words(Time.zone.now, Time.zone.now + 30.minutes),
        total: (1..20).map { rand(1000) },
        deaths: (1..20).map { rand(1000) },
        recovereds: (1..20).map { rand(1000) }
      },
      cities: City.cached_for_select
    )
  end

  private

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

  def get_beds
    if params[:hospital].present?
      return Hospital.find_by_slug(params[:hospital]).beds
    end

    City.is_active.find_by_slug(
      params[:city].present? ? params[:city] : 'ribeirao-preto'
    ).beds
  end

end
