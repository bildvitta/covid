# frozen_string_literal: true

module DataBridge::CovidCases
  class Paulinia < DataBridge::GoogleDriveBase
    def save!
      CovidCase.find_or_initialize_by(results[:find]).update(results[:data])
    end

    def get_data
      spreadsheet_key = Rails.application.credentials.paulinia_spreadsheet_key

      @worksheet = get_data_from_google_drive(spreadsheet_key).worksheets[1]

      process_cases

      Rails.cache.clear

      self
    end

    protected

    def process_cases
      self.results = {
        find: {
          city: City.find_by_slug('paulinia'),
          reference_date: Date.today
        },
        data: {
          total: @worksheet[2, 2],
          cureds: @worksheet[3, 2],
          deaths: @worksheet[4, 2]
        }
      }
    rescue StandardError => e
      puts "WARNING on generate CovidCase (reference date #{Date.today}): #{e}"
    end
  end
end
