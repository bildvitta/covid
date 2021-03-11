# frozen_string_literal: true
class Hospital < ApplicationRecord
  TYPES = [['Público', 1], ['Privado', 2], ['Filantrópico', 3]].freeze
  TYPE_ENUM = { 'public' => 1, 'private' => 2, 'filantropic' => 3 }.freeze

  belongs_to :city

  has_many :beds, dependent: :destroy
  has_many :bed_states, dependent: :destroy

  accepts_nested_attributes_for :beds

  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(name: :asc) }

  def self.hospital_slugs
    Rails.cache.fetch('hospital_api_values', expires_in: 30.minutes) do
      Hospital.pluck(:slug)
    end
  end

  def get_type
    TYPES.to_h.key(hospital_type)
  end

  def to_json
    total = busy = 0

    beds.each do |bed|
      next unless Bed.covid_types.include?(bed.bed_type)

      busy += 1 if bed.busy?
      total += 1
    end

    {
      name: name,
      value: slug,
      type: get_type,
      latitude: latitude,
      longitude: longitude,
      total: total,
      busy: busy,
      updated_at: beds[0]&.updated_at&.iso8601
    }
  end
end
