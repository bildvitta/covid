# frozen_string_literal: true

module DataBridge
  class Paulinia < DataBridge::GoogleDriveBase

    def save!
      Hospital.find_by_slug('hospital-paulinia').beds.destroy_all

      super
    end

    def get_data
      @worksheet = get_data_from_google_drive.worksheets[0]

      process_beds

      self.data = nil if Rails.env.production?

      Rails.cache.clear

      self
    end

    def get_data_from_google_drive
      spreadsheet = DataBridge::GoogleDriveBase.new.start_session(Rails.application.credentials.google_drive_config)
      spreadsheet = spreadsheet.get_spreadsheet(Rails.application.credentials.paulinia_spreadsheet_key)

      spreadsheet
    end

    protected

    def process_beds
      self.results = []
      # return unless valid_data?

      # create_result(bed_type, total_position, busy_position)
      # Total UTI-Covid
      create_result(1, [2, 2], [2, 3])
      # Total UTI Não-Covid
      create_result(2, [2, 4], [2, 5])
      # Total Enfermaria Covid
      create_result(3, [2, 6], [2, 7])
      # Total Enfermaria Não-Covid
      create_result(4, [2, 8], [2, 9])
    end

    def create_result(bed_type, total_position, busy_position)
      total = @worksheet[*total_position]
      busy = @worksheet[*busy_position]

      (total.to_i - busy.to_i).times do |i|
        results << DataBridge::InternalObject.new(
          hospital_slug: 'hospital-paulinia',
          status: :free,
          bed_type: bed_type,
          slug: "hospital-paulinia-#{bed_type}-free-#{i}",
          using_ventilator: false
        )
      end

      busy.to_i.times do |i|
        results << DataBridge::InternalObject.new(
          hospital_slug: 'hospital-paulinia',
          status: :busy,
          bed_type: bed_type,
          slug: "hospital-paulinia-#{bed_type}-busy-#{i}",
          using_ventilator: false
        )
      end
    end
  end
end
