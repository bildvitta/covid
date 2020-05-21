class AddDateToCovidCase < ActiveRecord::Migration[6.0]
  def change
    add_column :covid_cases, :reference_date, :date
  end
end
