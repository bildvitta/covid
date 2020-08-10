# frozen_string_literal: true

module DataBridge::CovidCases
  class Paulinia < DataBridge::GoogleDriveBase
    def save!
      CovidCase.find_or_initialize_by(results[:find]).update(results[:data])
    end

    def get_data
      spreadsheet = get_data_from_google_drive
      @worksheet = spreadsheet.worksheets[1]

      process_cases

      Rails.cache.clear

      self
    end

    def get_data_from_google_drive
      spreadsheet = DataBridge::GoogleDriveBase.new.start_session(Rails.application.credentials.google_drive_config)
      spreadsheet = spreadsheet.get_spreadsheet(Rails.application.credentials.paulinia_spreadsheet_key)

      spreadsheet
    end

    protected

    def process_cases
      self.results = {
        find: {
          city: City.find_by_slug('paulinia'),
          reference_date: Date.today - 1.day
        },
        data: {
          total: @worksheet[2, 2],
          cureds: @worksheet[3, 2],
          deaths: @worksheet[4, 2]
        }
      }
    rescue StandardError => e
      puts "WARNING on generate CovidCase (reference date #{Date.today - 1.day}): #{e}"
    end
  end
end
