module DataBridge
  class BeneficenciaPortuguesa < DataBridge::PostgresBase

    def connection_data
      Rails.application.credentials.beneficencia_connection
    end

    def get_data
      self.load_by_query('SELECT * FROM "PACIENTE"."leitos_codvid_v"')
      process_beds

      self.close_connection!

      self.data = nil if Rails.env.production?
      return self
    end

    protected

    def process_beds
      self.results = []
      return unless self.valid_data?

      self.data.each do |r|
        self.results << DataBridge::InternalObject.new(
          hospital_slug:    'beneficencia-portuguesa',
          status:           get_status(r['bloqueio']),
          bed_type:         get_bed_type(r['tipo']),
          slug:             r['leito'].parameterize,
          using_ventilator: false
        )
      end
    end

    def get_bed_type bed_type
      case bed_type.to_s.gsub('.', '').strip.downcase
      when 'uco', 'uti', 'un semi intensiva'
        return 1
      when 'enfermaria', 'apartamento'
        return 3
      else
        return 0
      end
    end

    def get_status status
      case status.to_s.downcase.strip.to_sym
      when :livre
        return :free
      when :ocupado, :transformado
        return :busy
      else
        return :unavailable
      end
    end

  end
end
