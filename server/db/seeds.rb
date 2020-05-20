def fake_historical hospital
  30.times do |i|
    bed_state = BedState.create!(
      date: (30 - i).days.ago, hospital: hospital
    )

    [true, false].each do |using_ventilator|
      Bed::TYPES.each do |_label, value|
        BedStateDetail.create!(
          using_ventilator: using_ventilator,

          bed_state_id: bed_state.id,
          bed_type: value,
          status_free: rand(1000),
          status_busy: rand(1000),
          status_unavailable: rand(1000),
        )
      end
    end
  end
end

if Hospital.none?
  rand_geocoded = -> { ([-1, 1].sample * rand(0..1.0).round(6)) }
  cities = City.offset(rand(35)).limit(3)

  city = City.find_by_slug('ribeirao-preto')

  unless city.nil?
    [
      {
        name: 'Hospital Unimed',
        hospital_type: 2,
        city: city,
        latitude: -21.225617,
        longitude: -47.816327
      },
      {
        name: 'Hospital São Lucas',
        hospital_type: 2,
        city: city,
        latitude: -21.188736,
        longitude: -47.803895
      },
      {
        name: 'Ribeirânia (Hospital São Lucas Ribeirânia)',
        hospital_type: 2,
        city: city,
        latitude: -21.200055,
        longitude: -47.787171
      },
      {
        name: 'Hospital Especializado',
        hospital_type: 2,
        city: city,
        latitude: -21.207647,
        longitude: -47.823695
      },
      {
        name: 'Hospital Santa Casa de Misericórdia de Ribeirão Preto',
        hospital_type: 1,
        city: city,
        latitude: -21.167811,
        longitude: -47.805911
      },
      {
        name: 'Hospital São Paulo',
        hospital_type: 2,
        city: city,
        latitude: -21.184408,
        longitude: -47.815726
      },
      {
        name: 'Beneficência Portuguesa',
        hospital_type: 1,
        city: city,
        latitude: -21.180653,
        longitude: -47.813874
      }
    ].each do |hospital|
      hospital = Hospital.create!(hospital)

      fake_historical(hospital)
    end
  end

  DataBridge::Unimed.new.get_data.save!

  cities.each do |city|
    rand(2..7).times do
      hospital = Hospital.create!(
        city: city,
        hospital_type: Hospital::TYPES.sample.last,
        name: Faker::Company.name,
        latitude: city.latitude + rand_geocoded.(),
        longitude: city.longitude + rand_geocoded.(),
        beds_attributes: (1..15).map do
          {
            status: Bed.statuses.values.sample,
            bed_type: Bed::TYPES.sample.last,
            using_ventilator: rand(2).zero?
          }
        end
      )

      fake_historical(hospital)
    end
  end

end

if CovidCase.none?
  City.all.each do |city|
    30.times do |i|
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
