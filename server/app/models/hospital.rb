class Hospital < ApplicationRecord
  TYPES = [['Público', 1], ['Privado', 2]]

  belongs_to :city

  has_many :beds, dependent: :destroy

  accepts_nested_attributes_for :beds

  extend FriendlyId
  friendly_id :name, use: :slugged

  def get_type
    TYPES.to_h.key(hospital_type)
  end

  def to_json
    {
      name: name,
      type: get_type,
      latitude: latitude,
      longitude: longitude,
      total: beds.covids.count,
      budy: beds.covids.busy.count
    }
  end
end
