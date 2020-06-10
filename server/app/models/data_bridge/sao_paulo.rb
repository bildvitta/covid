module DataBridge
  class SaoPaulo < DataBridge::MysqlBase

    def connection_data
      Rails.application.credentials.sao_paulo_connection
    end

    def get_data
      self.load_by_query('SELECT * FROM leitos_hp_sao_paulo')
      process_beds

      self.run_query('TRUNCATE TABLE leitos_hp_sao_paulo') if Rails.env.production?
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
          hospital_slug:    'hospital-sao-paulo',
          status:           get_status(r['STATUS']),
          bed_type:         get_bed_type(r['TIPO_DO_LEITO']),
          slug:             r['IDENTIFICADOR_LEITO'].parameterize,
          using_ventilator: r['USANDO_RESPIRADOR'] == 'TRUE'
        )
      end
    end

  end
end
