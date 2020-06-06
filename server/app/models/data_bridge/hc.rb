module DataBridge
  class Hc < DataBridge::WebServiceBase

    def connection_data
      Rails.application.credentials.hc_connection
    end

    def get_data
      self.request_api( 'covid/', {}, {}, {}, { token: '/HcrpSSO/api/v1/auth', http_method: :get } )
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
          hospital_slug:    get_hospital_slug(r['identificadorHospital']),
          status:           get_status(r['status']),
          bed_type:         get_bed_type(r['tipoDoLeito']),
          slug:             r['identificadorLeito'].parameterize,
          using_ventilator: r['usandoRespirador'].to_s == 'true',
        )
      end
    end

    def get_hospital_slug hospital_slug
      hospital_slug = hospital_slug.to_s.downcase.remove('hcrp - ').to_sym

      case hospital_slug
      when :campus
        return 'hc-campus-ribeirao-preto'
      else
        return 'hc-emergencia-ribeirao-preto'
      end
    end

  end
end
