class CreateBedStateDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :bed_state_details do |t|
      t.boolean :using_ventilator, default: false

      t.integer :bed_state_id, index: true
      t.integer :bed_type, default: 1 # 1 ICU COVID, 2 ICU NOT-COVID, 3 nursery COVID, 4 nursery NOT-COVID
      t.integer :status_free, default: 0
      t.integer :status_busy, default: 0
      t.integer :status_unavailable, default: 0

      t.timestamps
    end
  end
end