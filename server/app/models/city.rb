class City < ApplicationRecord
  belongs_to :state

  has_many :hospitals
  has_many :beds, through: :hospitals

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :is_active, -> { joins(:hospitals).includes(:state, :hospitals) }

  validates_presence_of :name, :state

  def get_city_state
    "#{name} - #{state.prefix}"
  end

  def self.cached_for_select
    Rails.cache.fetch(:city_for_select) do
      is_active.map do |city|
        hospitals = [{ label: 'Todos', value: '' }]

        hospitals.concat(
          city.hospitals.map do |hospital|
            { label: hospital.name, value: hospital.slug }
          end
        )

        {
          label: city.get_city_state,
          value: city.slug,
          hospitals: hospitals
        }
      end
    end
  end
end
