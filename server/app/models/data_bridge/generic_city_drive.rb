# frozen_string_literal: true

module DataBridge
  # This class has the intend to simplify future generic google drive sheets
  class CityDriveBase < DataBridge::GoogleDriveBase
    MULTIPLE_HOSPITAL_WARNING = I18n.t('development_notes.hospital_warning')
    HOSPITAL_NOT_FOUND_MESSAGE = I18n.t('activerecord.passive_errors.not_found', count: 1, arg: Hospital.model_name.human)
    CREDENTIALS_NOT_FOUND_MESSAGE = I18n.t('activerecord.passive_errors.not_found', count: 2, arg: I18n.t('development_notes.credentials'))
    TO_DO_TYPES = %i[beds cases].freeze

    attr_accessor :city, :hospital, :credentials, :to_do, :cases_results
    # Makes the 'save!' method from super class be called 'super_save!', so it can be accessed anywhere
    alias super_save! save!

    def initialize(city, to_do: TO_DO_TYPES)
      self.city = (city.is_a?(City) ? city : City.friendly.find(city))
      self.hospital = retrieve_hospital
      self.credentials = retrieve_credentials
      self.to_do = [to_do].flatten.freeze

      super()
    end

    def save!
      to_do.each { |type| hard_send("save_#{type}") }

      true
    end

    def get_data
      self.results = []
      self.cases_results = nil

      file = get_data_from_google_drive(credentials)

      # Treats each datas separately
      to_do.each do |type|
        @worksheet = file.worksheets[TO_DO_TYPES.index(type)]
        # Hard send is defined later on the code
        hard_send("process_#{type}")
      end

      self.data = nil if Rails.env.production?
      Rails.cache.clear

      self
    end

    protected

    def process_beds
      # Total UTI-Covid
      create_result(1, [2, 2], [2, 3])
      # Total UTI Não-Covid
      create_result(2, [2, 4], [2, 5])
      # Total Enfermaria Covid
      create_result(3, [2, 6], [2, 7])
      # Total Enfermaria Não-Covid
      create_result(4, [2, 8], [2, 9])
    end

    def process_cases
      self.cases_results = {
        find: { city: city, reference_date: Date.today },
        data: { total: @worksheet[2, 2], cureds: @worksheet[3, 2], deaths: @worksheet[4, 2] }
      }
    rescue StandardError => e
      puts "WARNING on generate CovidCase (reference date #{Date.today}): #{e}"
    end

    def save_beds
      hospital.beds.destroy_all

      super_save!
    end

    def save_cases
      CovidCase.find_or_initialize_by(cases_results[:find]).update(cases_results[:data])
    end

    def create_result(bed_type, total_position, busy_position)
      total = @worksheet[*total_position]
      busy = @worksheet[*busy_position]

      (total.to_i - busy.to_i).times do |i|
        results << create_object(bed_type, :free, i)
      end

      busy.to_i.times do |i|
        results << create_object(bed_type, :busy, i)
      end
    end

    def create_object(bed_type, status, iterator)
      DataBridge::InternalObject.new(
        hospital_slug: hospital.slug,
        status: status,
        bed_type: bed_type,
        slug: "#{hospital.slug}-#{bed_type}-#{status}-#{iterator}",
        using_ventilator: false
      )
    end

    # Since it's a very generic class, it's very well protected to avoid too much debugging
    private

    # It's the same thing as usual send, but warns the developer in case he miss the method creation
    # Might be useless, but since it's a class that might be used for a lot of cities, and might be
    # used as another class' superclass, this method might help to abstract this class and debug
    def hard_send(symbol)
      begin
        send_method = method(symbol)
      rescue NameError => e
        raise NotImplementedError, I18n.t('activerecord.passive_errors.method_not_defined', method: e.name)
      end
      send_method.call
    end

    def retrieve_credentials
      credentials = Rails.application.credentials.send("#{city.slug}_spreadsheet_key")
      return credentials if credentials

      raise NotImplementedError, CREDENTIALS_NOT_FOUND_MESSAGE
    end

    def retrieve_hospital
      return @retrieve_hospital if @retrieve_hospital

      @retrieve_hospital = city.hospitals
      hospital_countage = @retrieve_hospital.length

      raise ActiveRecord::RecordNotFound, HOSPITAL_NOT_FOUND_MESSAGE if hospital_countage.zero?

      puts MULTIPLE_HOSPITAL_WARNING if hospital_countage > 1

      @retrieve_hospital = @retrieve_hospital.first
      @retrieve_hospital
    end
  end
end
