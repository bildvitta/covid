class CovidCase < ApplicationRecord
  belongs_to :city

  def to_json
    {
      total: total,
      deaths: deaths,
      cureds: cureds
    }
  end

  def self.populate_with_api
    city = (City.find_by slug: 'ribeirao-preto').id
    covid = self.get_data_from_api
    covid[:results].each do |data|
      if (CovidCase.where("reference_date = :reference_date AND city_id = :city", {reference_date: data[:date], city: city}).count < 1)
        CovidCase.create(city_id: city, total: data[:confirmed], deaths: data[:deaths], reference_date: data[:date])
      end
    end
  end

  def self.get_data_from_api
    data = JSON.parse(RestClient::Resource.new('https://brasil.io/api/dataset/covid19/caso/data?city=Ribeir%C3%A3o%20Preto').get.body).with_indifferent_access
  end
end
