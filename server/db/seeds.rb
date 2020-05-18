if Hospital.none?
  rand_geocoded = -> { ([-1, 1].sample * rand(0..1.0).round(6)) }
  cities = City.offset(rand(35)).limit(3)

  unless cities.exists?(slug: 'ribeirao-preto')
    cities = cities.to_a + [City.find_by_slug('ribeirao-preto')]
  end

  bed_block = -> (bed = nil) {
    {
      status: Bed.statuses.values.sample,
      bed_type: Bed::TYPES.sample.last,
      using_ventilator: rand(2).zero?
    }
  }

  cities.each do |city|
    rand(2..7).times do
      Hospital.create!(
        city: city,
        hospital_type: Hospital::TYPES.sample.last,
        name: Faker::Company.name,
        latitude: city.latitude + rand_geocoded.(),
        longitude: city.longitude + rand_geocoded.(),
        beds_attributes: (1..15).map(&bed_block)
      )
    end
  end

  Bed.all.each do |bed|
    15.times do |i|
      bed.update(
        bed_block.().merge(
          updated_at: (15 - i).days.ago
        )
      )
    end
  end
end

if CovidCase.none?
  City.all.each do |city|
    rand(6..30).times do |i|
      deaths = rand(500)
      cureds = rand(500)
      total = cureds + deaths

      covid_case = CovidCase.create!(
        city: city,
        total: rand(total..(total + 500)),
        deaths: deaths,
        cureds: cureds,
        created_at: i.days.ago
      )
    end
  end
end