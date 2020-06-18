class Hospital < ApplicationRecord
  TYPES = [['Público', 1], ['Privado', 2]]

  belongs_to :city

  has_many :beds, dependent: :destroy
  has_many :bed_states, dependent: :destroy

  accepts_nested_attributes_for :beds

  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(name: :asc) }

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
      busy: busy
    }
  end
end
