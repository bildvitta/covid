class City < ApplicationRecord
  belongs_to :state

  has_many :covid_cases
  has_many :hospitals
  has_many :beds, through: :hospitals

  extend FriendlyId
  friendly_id :name, use: :slugged

  after_commit :flush_cache

  validates_presence_of :name, :state

  scope :is_active, -> { joins(:hospitals).includes(:state, :hospitals) }

  def flush_cache hospital = nil
    Rails.cache.delete([self.class, "cached_city_#{slug}"])

    Rails.cache.delete([:beds_data, slug, hospital&.slug])
    Rails.cache.delete([:beds_data, slug, nil])
  end

  def get_city_state
    "#{name} - #{state.prefix}"
  end

  def self.cached_for(slug)
    Rails.cache.fetch([name, "cached_city_#{slug}"], expires_in: rand(10..17).minutes) do
      City.includes(:state, :covid_cases, :hospitals).is_active.find_by_slug(slug)
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
