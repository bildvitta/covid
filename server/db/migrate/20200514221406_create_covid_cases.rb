class CreateCovidCases < ActiveRecord::Migration[6.0]
  def change
    create_table :covid_cases do |t|
      t.integer :city_id, index: true
      t.integer :total, default: 0
      t.integer :deaths, default: 0
      t.integer :cureds, default: 0

      t.timestamps
    end
  end
end
