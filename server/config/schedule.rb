set :chronic_options, hours24: true

every 1.day, at: '0:30' do
  runner 'Routines::GenerateHistorical.new(1.day.ago.to_date).run!'
end
