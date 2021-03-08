class CreateCities < ActiveRecord::Migration[6.0]
  def migrate(direction)
    super

    return unless direction == :up

    print "\rCriando cidades...#{' ' * 20}"

    cities = JSON.parse(File.read(Rails.root.join('db', 'seeds', 'cities.json').to_s))
    total_cities = cities.count

    cities.each_with_index do |city, i|
      print "\rCriando cidade #{i + 1}/#{total_cities}..." + (' ' * 20)

      break if Rails.env.development? && i > 50

      City.create!(json_to_params(city))
    end

    ['Ribeirão Preto', 'Paulínia'].each do |city_name|
      next if City.exists?(name: city_name)

      city_json = cities.find { |city_array| city_array.first == city_name }
      next unless city_json

      City.create!(json_to_params(city_json))
    end
  end

  def change
    create_table :cities do |t|
      t.integer :state_id, index: true
      t.string :name
      t.string :slug, unique: true
      t.float :latitude, index: true
      t.float :longitude, index: true

      t.timestamps
    end
  end

  private

  def json_to_params(array)
    %i[name state_id latitude
       longitude].each_with_index.each_with_object({}) do |(key, index), memo|
      memo[key] = array[index]
    end
  end
end
