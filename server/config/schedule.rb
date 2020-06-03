set :chronic_options, hours24: true

every 1.day, at: '0:30' do
  runner 'Routines::GenerateHistorical.new(1.day.ago.to_date).run!'
end

every 1.day, at: '1:30' do
  runner 'CovidCase.populate_with_api'
end

every 1.day, at: ['0:05', '6:05', '13:05', '19:05'] do
  runner "DataBridge::Unimed.new.get_data.save!"
end

every 1.day, at: ['0:07', '6:07', '13:07', '19:07'] do
  runner "DataBridge::SaoLucas.new.get_data.save!"
end

every 1.day, at: ['0:10', '6:10', '13:10', '19:10'] do
  runner "DataBridge::SantaCasa.new.get_data.save!"
end


# undefined method `children' for nil:NilClass
# DataBridge::Unimed.new.get_data.save!; DataBridge::SaoLucas.new.get_data.save!; DataBridge::SantaCasa.new.get_data.save!; Routines::GenerateHistorical.new(1.day.ago.to_date).run!
