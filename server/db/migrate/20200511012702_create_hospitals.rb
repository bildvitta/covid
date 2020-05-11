class CreateHospitals < ActiveRecord::Migration[6.0]
  def change
    create_table :hospitals do |t|
      t.integer :city_id
      t.integer :hospital_type, default: 1 # 1 - public, 2 - private
      t.string :name
      t.string :slug # identifier

      t.timestamps
    end
    add_index :hospitals, :slug, unique: true
  end
end
