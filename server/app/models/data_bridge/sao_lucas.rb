module DataBridge
  class SaoLucas < DataBridge::MysqlBase

    def connection_data
      Rails.application.credentials.sao_lucas_connection
    end

    def get_data
      self.load_by_query('SELECT * FROM leitos')
      process_beds

      self.run_query('TRUNCATE TABLE leitos') if Rails.env.production?
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
          hospital_slug:    get_hospital_slug(r['identificador_hospital']),
          status:           get_status(r['status']),
          bed_type:         get_bed_type(r['tipo_do_leito']),
          slug:             r['identificador_leito'].parameterize,
          using_ventilator: r['usando_respirador'].to_i == 1,
        )
      end
    end

    def get_hospital_slug hospital_slug
      hospital_slug = hospital_slug.to_s.downcase.remove('sao lucas - ').to_sym

      case hospital_slug
      when :especializado
        return 'hospital-especializado'
      when :ribeirania
        return 'sao-lucas-ribeirania'
      else
        return 'hospital-sao-lucas'
      end
    end

  end
end
