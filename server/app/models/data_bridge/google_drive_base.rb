# frozen_string_literal: true

module DataBridge
  class GoogleDriveBase < DataBridge::Base
    attr_accessor :session

    def start_session(config)
      self.session = GoogleDrive::Session.from_service_account_key(config)
      self
    end

    def get_spreadsheet(key)
      session.spreadsheet_by_key(key)
    end

    def get_data_from_google_drive(spreadsheet_key)
      start_session(Rails.application.credentials.google_drive_config)
      get_spreadsheet(spreadsheet_key)
    end
  end
end
