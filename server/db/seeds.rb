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
        slug: 'sao-lucas-ribeirania',
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
        slug: 'santa-casa-ribeirao',
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
      },
      {
        name: 'Hospital Santa Lydia',
        hospital_type: 1,
        city: city,
        latitude: -21.170,
        longitude: -47.802
      },
      {
        name: 'Hospital das Clínicas',
        slug: 'hc-campus-ribeirao-preto',
        hospital_type: 1,
        city: city,
        latitude: -21.1624149,
        longitude: -47.8544455
      },
      {
        name: 'Hospital das Clínicas Unidade de Emergência',
        slug: 'hc-emergencia-ribeirao-preto',
        hospital_type: 1,
        city: city,
        latitude: -21.185455,
        longitude: -47.8084284
      },
      {
        name: 'Hospital São Francisco',
        hospital_type: 1,
        city: city,
        latitude: -21.1854888,
        longitude: -47.8096485
      },
      {
        name: 'Hospital Paulínia',
        slug: 'hospital-paulinia',
        hospital_type: 1,
        city: City.find_by_slug('paulinia'),
        latitude: -22.7727157,
        longitude: -47.1591621
      },
      {
        name: 'Polo COVID - UPA Treze de Maio',
        slug: 'polo-covid-upa-treze-de-maio',
        hospital_type: 1,
        city: city,
        latitude: -21.1761612,
        longitude: -47.7922277
      },
      {
        name: 'Polo COVID 2 - UPA Central',
        slug: 'polo-covid-2-upa-central',
        hospital_type: 1,
        city: city,
        latitude: -21.1726925,
        longitude: -47.8143013
      },
      {
        name: 'Hospital Estadual de Ribeirão Preto',
        slug: 'hospital-estadual-ribeirao-preto',
        hospital_type: 1,
        city: city,
        latitude: -21.2115222,
        longitude: -47.8290127
      }
    ].each do |hospital|
      hospital = Hospital.create!(hospital)

      fake_historical(hospital)
    end
  end

  # DataBridge::Unimed.new.get_data.save!
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
        reference_date: i.days.ago
      )
    end
  end
end
