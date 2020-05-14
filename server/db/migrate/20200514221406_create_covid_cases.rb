class CreateCovidCases < ActiveRecord::Migration[6.0]
  def change
    create_table :covid_cases do |t|
      t.integer :city_id, index: true
      t.integer :total
      t.integer :deaths
      t.integer :cureds

      t.timestamps
    end
  end
end
