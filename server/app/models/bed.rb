class Bed < ApplicationRecord
  enum status: { free: 1, busy: 2, unavailable: 3 }

  include BedTypes

  # Leitos do tipo extra, não estão sendo considerados como leitos livres
  # Rotina de geração de historico e beds_data no controller
  TYPES = [
    ['UTI COVID', 1],
    ['UTI NÃO-COVID', 2],
    ['Enfermagem COVID', 3],
    ['Enfermagem NÃO-COVID', 4],
    ['UTI COVID Extra', 5],
    ['Enfermagem COVID Extra', 6]
  ]

  belongs_to :hospital

  after_commit -> { hospital.city.flush_cache hospital }

  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  scope :using_ventilator, -> { where(using_ventilator: true) }

  validates_uniqueness_of :slug, scope: :hospital_id

  def generate_slug
    [hospital.name, bed_type].join(' ')
  end
end
