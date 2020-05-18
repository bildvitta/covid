class CreateBedStates < ActiveRecord::Migration[6.0]
  def change
    create_table :bed_states do |t|
      t.integer :bed_id, index: true
      t.integer :status, default: 1 # 1 free, 2 busy, 3 unavailable
      t.integer :bed_type, default: 1 # 1 ICU COVID, 2 ICU NOT-COVID, 3 nursery COVID, 4 nursery NOT-COVID

      t.boolean :using_ventilator, default: false

      t.timestamps
    end
  end
end
