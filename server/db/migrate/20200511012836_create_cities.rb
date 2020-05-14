class CreateCities < ActiveRecord::Migration[6.0]
  def migrate(direction)
    super

    if direction == :up
      print "\rCriando cidades..."+(' '*20)

      cities = JSON.parse(File.read(Rails.root.join('db', 'seeds', 'cities.json').to_s))
      total_cities = cities.count

      cities.each_with_index do |city,i|
        print "\rCriando cidade #{i + 1}/#{total_cities}..."+ (' ' * 20)

        break if Rails.env.development? && i > 50 

        City.create!(name: city[0], state_id: city[1], latitude: city[2], longitude: city[3])
      end

      unless City.exists?(slug: 'ribeirao-preto')
        City.create!(name: 'Ribeirão Preto', state_id: 25, latitude: -21.1699, longitude: -47.8099)
      end
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
end
