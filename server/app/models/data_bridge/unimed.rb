module DataBridge
  class Unimed < DataBridge::WebServiceBase

    def connection_data
      {
        hostname: 'dadoshurpcovid.unimedribeirao.net',
        port: 443, use_ssl: true, base_path: '/'
      }
    end

    attr_accessor :results

    def get_data
      payload = { id: 'WSHURP', key: 'lrnHJQ8YkFy7S75X3efwFXU3csdmcoFo', type: 'A' }
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      self.request_api( 'index.aspx', {}, payload, headers, { payload_processor: :to_query } ) do |request|
        request.to_s.split('<!DOCTYPE html>').first
      end
      process_beds

      self.data = nil if Rails.env.production?
      return self
    end

    protected

    def process_beds
      self.results = []

      return unless self.valid_data?

      self.data.each do |r|
        self.results << DataBridge::InternalObject.new(
          hospital_slug: 'hospital-unimed',
          status: get_status(r['Status']),
          bed_type: get_bed_type(r['TipoLeito']),
          slug: r['IdLeito'].parameterize,
          using_ventilator: r['UsandoRespirador'] == 'true',
        )
      end
    end

  end
end
