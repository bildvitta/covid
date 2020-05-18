class CreateHospitals < ActiveRecord::Migration[6.0]
  def change
    create_table :hospitals do |t|
      t.integer :city_id, index: true
      t.integer :hospital_type, default: 1 # 1 - public, 2 - private

      t.string :name
      t.string :slug, index: true, unique: true

      t.float :latitude, index: true
      t.float :longitude, index: true

      t.timestamps
    end
  end
end
