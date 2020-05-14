class City < ApplicationRecord
  belongs_to :state

  has_many :covid_cases
  has_many :hospitals
  has_many :beds, through: :hospitals

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :is_active, -> { joins(:hospitals).includes(:state, :hospitals) }

  validates_presence_of :name, :state

  after_commit :flush_cache

  def flush_cache
    Rails.cache.delete([self.class, "cached_city_#{slug}"])
  end

  def get_city_state
    "#{name} - #{state.prefix}"
  end

  def self.cached_for(slug)
    Rails.cache.fetch([name, "cached_city_#{slug}"]) do
      City.includes(:state, :hospitals).is_active.find_by_slug(slug)
    end
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
