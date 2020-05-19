class Bed < ApplicationRecord
  enum status: { free: 1, busy: 2, unavailable: 3 }

  TYPES = [
    ['UTI COVID', 1],
    ['UTI NÃO-COVID', 2],
    ['Enfermagem COVID', 3],
    ['Enfermagem NÃO-COVID', 4]
  ]

  belongs_to :hospital

  has_many :bed_states, dependent: :destroy

  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  scope :using_ventilator, -> { where(using_ventilator: true) }
  scope :covids, -> { where(bed_type: Bed.covid_types) }
  scope :no_covids, -> { where(bed_type: Bed.normal_types) }

  def generate_slug
    [hospital.name, bed_type].join(' ')
  end

  def self.covid_types
    [1, 3]
  end

  def self.normal_types
    [2, 4]
  end
end
