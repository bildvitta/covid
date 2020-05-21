class Bed < ApplicationRecord
  enum status: { free: 1, busy: 2, unavailable: 3 }

  include BedTypes

  TYPES = [
    ['UTI COVID', 1],
    ['UTI NÃO-COVID', 2],
    ['Enfermagem COVID', 3],
    ['Enfermagem NÃO-COVID', 4]
  ]

  belongs_to :hospital

  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  scope :using_ventilator, -> { where(using_ventilator: true) }

  validates_uniqueness_of :slug, scope: :hospital_id

  def generate_slug
    [hospital.name, bed_type].join(' ')
  end
end
