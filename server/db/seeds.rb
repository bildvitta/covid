if Hospital.none?
  cities = City.offset(rand(35)).limit(3).to_a

  cities << City.find_by_slug('ribeirao-preto')

  cities.each do |city|
    rand(2..7).times do
      Hospital.create!(
        city: city,
        hospital_type: Hospital::TYPES.sample.last,
        name: Faker::Company.name,
        beds_attributes: (1..15).map do
          {
            status: Bed.statuses.values.sample,
            bed_type: Bed::TYPES.sample.last,
            using_ventilator: rand(2).zero?
          }
        end
      )
    end
  end
end