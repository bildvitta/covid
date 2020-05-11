class CreateCities < ActiveRecord::Migration[6.0]
  def migrate(direction)
    super

    if direction == :up
      print "\rCriando cidades..."+(' '*20)

      cities = JSON.parse(File.read(Rails.root.join('db', 'seeds', 'cities.json').to_s))
      total_cities = cities.count

      cities.each_with_index do |city,i|
        print "\rCriando cidade #{i+1}/#{total_cities}..."+(' '*20)
        City.create!(name: city[0], state_id: city[1], latitude: city[2], longitude: city[3])
      end
    end
  end

  def change
    create_table :cities do |t|
      t.integer :state_id
      t.string :name
      t.string :slug
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :cities, :slug, unique: true
  end
end
