# frozen_string_literal: true

set :chronic_options, hours24: true

every 1.day, at: '0:30' do
  runner 'Routines::GenerateHistorical.new(1.day.ago.to_date).run!'
end

every '2 * * * *' do
  # runner 'CovidCase.populate_with_api'
  runner 'CovidCase.google_drive_sheets'
end

every 1.day, at: '19:00' do
  runner 'DataBridge::SaoFrancisco.new.get_data.save!'
end

every '7 * * * *' do
  runner 'DataBridge::Unimed.new.get_data.save!'
end

every '10 * * * *' do
  runner 'DataBridge::SaoLucas.new.get_data.save!'
end

every '5 * * * *' do
  runner 'DataBridge::SaoPaulo.new.get_data.save!'
end

every 1.day, at: ['0:09', '6:09', '13:09', '19:09'] do
  runner 'DataBridge::SantaCasa.new.get_data.save!'
end

every 1.day, at: ['0:12', '6:12', '13:12', '19:12'] do
  runner 'DataBridge::BeneficenciaPortuguesa.new.get_data.save!'
end

every '15 * * * *' do
  runner 'DataBridge::SantaLydia.new.get_data.save!'
end

every 1.day, at: ['0:18', '6:18', '13:18', '19:18'] do
  runner 'DataBridge::Hc.new.get_data.save!'
end

every 1.day, at: ['0:20', '6:24', '13:24', '19:24'] do
  runner 'DataBridge::Paulinia.new.get_data.save!'
end

every '2 * * * *' do
  runner 'DataBridge::CovidCases::Paulinia.new.get_data.save!'
end
