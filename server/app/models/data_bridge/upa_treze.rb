# frozen_string_literal: true

module DataBridge
  class UpaTreze < DataBridge::GoogleDriveBase
    def save!
      Hospital.find_by_slug('polo-covid-upa-treze-de-maio').beds.destroy_all

      super
    end

    def get_data
      spreadsheet_key = Rails.application.credentials.upa_treze_spreadsheet_key

      @worksheet = get_data_from_google_drive(spreadsheet_key).worksheets[0]

      process_beds

      self.data = nil if Rails.env.production?

      Rails.cache.clear

      self
    end

    protected

    def process_beds
      self.results = []
      # return unless valid_data?

      # create_result(bed_type, total_position, busy_position)
      [:treze, :central, :pronto].each_with_index do |unit, i|
        # Total UTI-Covid
        create_result(unit, 1, [(i + 2), 2], [(i + 2), 3])
        # Total UTI Não-Covid
        create_result(unit, 2, [(i + 2), 4], [(i + 2), 5])
        # Total Enfermaria Covid
        create_result(unit, 3, [(i + 2), 6], [(i + 2), 7])
        # Total Enfermaria Não-Covid
        create_result(unit, 4, [(i + 2), 8], [(i + 2), 9])
      end
    end

    def create_result(unit, bed_type, total_position, busy_position)
      total = @worksheet[*total_position]
      busy = @worksheet[*busy_position]

      (total.to_i - busy.to_i).times do |i|
        results << create_object(unit, bed_type, :free, i)
      end

      busy.to_i.times do |i|
        results << create_object(unit, bed_type, :busy, i)
      end
    end

    def create_object(unit, bed_type, status, iterator)
      units = {
        treze: ['polo-covid-upa-treze-de-maio', 'polo-covid-upa-treze'],
        central: ['polo-covid-2-upa-central', 'polo-covid-2-upa-central'],
        pronto: ['pronto-atendimento-ribeirao-preto', 'pronto-atendimento']
      }

      DataBridge::InternalObject.new(
        hospital_slug: units[unit][0],
        status: status,
        bed_type: bed_type,
        slug: "#{units[unit][1]}-#{bed_type}-#{status}-#{iterator}",
        using_ventilator: false
      )
    end
  end
end
