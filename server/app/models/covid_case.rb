class CovidCase < ApplicationRecord
  belongs_to :city

  def to_json
    {
      created_at.to_date => {
        total: total,
        deaths: deaths,
        cureds: cureds
      }
    }
  end
end
