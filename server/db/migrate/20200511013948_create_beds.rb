class CreateBeds < ActiveRecord::Migration[6.0]
  def change
    create_table :beds do |t|
      t.integer :hospital_id
      t.integer :status, default: 1 # 1 free, 2 busy, 3 unavailable
      t.integer :bed_type, default: 1 # 1 ICU COVID, 2 ICU NOT-COVID, 3 nursery COVID, 4 nursery NOT-COVID

      t.string :slug, index: true, unique: true

      t.boolean :using_ventilator, default: false

      t.timestamps
    end
  end
end
