class CreateBedStates < ActiveRecord::Migration[6.0]
  def change
    create_table :bed_states do |t|
      t.integer :hospital_id, index: true

      t.date :date

      t.timestamps
    end
  end
end
