set :chronic_options, hours24: true

every 1.day, at: '0:30' do
  runner 'Routines::GenerateHistorical.new(1.day.ago.to_date).run!'
end

every 1.day, at: ['0:05', '6:05', '13:05', '19:05'] do
  runner "DataBridge::Unimed.new.get_data.save!"
end

every 1.day, at: ['0:07', '6:07', '13:07', '19:07'] do
  runner "DataBridge::SaoLucas.new.get_data.save!"
end
