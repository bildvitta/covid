class CovidCase < ApplicationRecord
  belongs_to :city

  def to_json
    {
      total: total,
      deaths: deaths,
      cureds: cureds
    }
  end
end
