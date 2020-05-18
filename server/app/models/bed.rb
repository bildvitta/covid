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

  after_commit :generate_state, if: -> { previous_changes.key?('updated_at') }

  scope :using_ventilator, -> { where(using_ventilator: false) }
  scope :covids, -> { where(bed_type: [1, 3]) }
  scope :no_covids, -> { where(bed_type: [2, 4]) }

  def generate_slug
    [hospital.name, bed_type].join(' ')
  end

  private

  def generate_state
    unless persisted? && next_day?(*previous_changes['updated_at'])
      return
    end

    state = %w[status bed_type using_ventilator].map do |column|
      [column, get_previous(column)]
    end

    bed_states.create!(state.to_h)
  end

  def next_day? last_date, current_date
    return false unless last_date && current_date

    last_date.day != current_date.day
  end

  def get_previous column
    previous_changes.key?(column) ? previous_changes[column].last : send(column)
  end
end
