module DataBridge
  class SaoFrancisco < DataBridge::WebServiceBase

    def connection_data
      Rails.application.credentials.sao_francisco_connection
    end

    def get_data
      headers = {
        'Content-Type' => 'application/json',
        'Ocp-Apim-Subscription-Key' => '51c12540beb4406e89c794bb5a84ea97'
      }

      self.request_api( 'covid19Leitos', {}, {}, headers, { http_method: :get } )
      process_beds

      self.data = nil if Rails.env.production?
      return self
    end

    protected

    def process_beds
      self.results = []
      return unless self.valid_data?

      self.data.each do |r|
        r['IDENTIFICADOR_HOSPITAL'] = get_hospital_slug(r['IDENTIFICADOR_HOSPITAL'])
        next if r['IDENTIFICADOR_HOSPITAL'] != 'hospital-sao-francisco'

        self.results << DataBridge::InternalObject.new(
          hospital_slug:    r['IDENTIFICADOR_HOSPITAL'],
          status:           get_status(r['STATUS']),
          bed_type:         get_bed_type(r['TIPO_DO_LEITO']),
          slug:             r['IDENTIFICADOR_LEITO'].parameterize,
          using_ventilator: r['DISPOSITIVO_INSTALADO'] == 'Ventilação Mecânica',
        )
      end
    end

    def get_hospital_slug hospital_slug
      return hospital_slug.to_s.parameterize
    end

    def get_status status
      case status.to_s.downcase.strip.to_sym
      when :livre
        return :free
      when :paciente
        return :busy
      else
        return :unavailable
      end
    end

    def get_bed_type bed_type
      case bed_type.to_s.downcase.split(' ').first
      when 'cti', 'tmo', 'uce'
        return 1
      when 'posto'
        return 3
      else
        return 0
      end
    end

  end
end
