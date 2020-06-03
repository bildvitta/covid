module DataBridge
  class SantaCasa < DataBridge::OracleBase

    def connection_data
      Rails.application.credentials.santa_casa_connection
    end

    def get_data
      self.load_by_query('SELECT * FROM covid')
      process_beds

      # self.close_connection!

      self.data = nil if Rails.env.production?
      return self
    end

    protected

    def process_beds
      self.results = []
      return unless self.valid_data?

      self.data.each do |r|
        self.results << DataBridge::InternalObject.new(
          hospital_slug:    'santa-casa-ribeirao',
          status:           get_status(r[3]),
          bed_type:         get_bed_type(r[2]),
          slug:             r[1].parameterize,
          using_ventilator: r[4].to_s.downcase == 'true',
        )
      end
    end

  end
end
