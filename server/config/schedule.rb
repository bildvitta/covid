set :chronic_options, hours24: true

every 1.day, at: '0:30' do
  runner 'Routines::GenerateHistorical.new(1.day.ago.to_date).run!'
end

every :hour do
  runner 'CovidCase.populate_with_api'
end

every 1.day, at: ['0:05', '6:05', '13:05', '19:05'] do
  runner "DataBridge::Unimed.new.get_data.save!"
end

every 1.day, at: ['0:07', '6:07', '13:07', '19:07'] do
  runner "DataBridge::SaoLucas.new.get_data.save!"
end

every 1.day, at: ['0:09', '6:09', '13:09', '19:09'] do
  runner "DataBridge::SantaCasa.new.get_data.save!"
end

every 1.day, at: ['0:12', '6:12', '13:12', '19:12'] do
  runner "DataBridge::BeneficenciaPortuguesa.new.get_data.save!"
end

every 1.day, at: ['0:15', '6:15', '13:15', '19:15'] do
  runner "DataBridge::SantaLydia.new.get_data.save!"
end

every 1.day, at: ['0:18', '6:18', '13:18', '19:18'] do
  runner "DataBridge::Hc.new.get_data.save!"
end
