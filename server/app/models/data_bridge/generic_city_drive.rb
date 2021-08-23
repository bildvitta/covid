# frozen_string_literal: true

module DataBridge
  # This class has the intend to simplify future generic google drive sheets
  class GenericCityDrive < DataBridge::GoogleDriveBase
    MULTIPLE_HOSPITAL_WARNING = I18n.t('development_notes.hospital_warning')
    HOSPITAL_NOT_FOUND_MESSAGE = I18n.t('activerecord.passive_errors.not_found', count: 1, arg: Hospital.model_name.human)
    CREDENTIALS_NOT_FOUND_MESSAGE = I18n.t('activerecord.passive_errors.not_found', count: 2, arg: I18n.t('development_notes.credentials'))
    TO_DO_TYPES = %i[beds cases].freeze

    attr_accessor :city, :hospital, :credentials, :to_do, :cases_results
    # Makes the 'save!' method from super class be called 'super_save!', so it can be accessed anywhere
    alias super_save! save!

    # @param [City, String] city
    # @param [Symbol, Array] to_do It can be :beds, :cases or both on array
    def initialize(city, to_do: TO_DO_TYPES)
      self.city = (city.is_a?(City) ? city : City.friendly.find(city))
      self.hospital = retrieve_hospital
      self.credentials = retrieve_credentials
      self.to_do = [to_do].flatten.freeze

      super()
    end

    # Persists all accessors data
    def save!
      to_do.each { |type| hard_send("save_#{type}") }

      true
    end

    # Stores all datas on accessors
    # @return [GenericCityDrive]
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

    # Proccess the different type of bed_types
    def process_beds
      # Total UTI-Covid
      create_result(1, [2, 2], [2, 3], [2, 10])
      # Total UTI Não-Covid
      create_result(2, [2, 4], [2, 5], [2, 11])
      # Total Enfermaria Covid
      create_result(3, [2, 6], [2, 7], [2, 12])
      # Total Enfermaria Não-Covid
      create_result(4, [2, 8], [2, 9], [2, 13])
    end

    def process_cases
      self.cases_results = {
        find: { city: city, reference_date: Date.today },
        data: { total: @worksheet[2, 2], cureds: @worksheet[3, 2], deaths: @worksheet[4, 2] }
      }
    rescue StandardError => e
      puts "WARNING on generate CovidCase (reference date #{Date.today}): #{e}"
    end

    # Commits beds stored on "results" accessor into the database
    def save_beds
      hospital.beds.destroy_all

      super_save!
    end

    # Commits cases stored on "cases_results" accessor into the database
    def save_cases
      CovidCase.find_or_initialize_by(cases_results[:find]).update(cases_results[:data])
    end

    # Uses "create_object" method to store DataBridge information on "results" accessor
    # @param [Integer] bed_type Enum for bed_type
    # @param [Array] total_position Array equivalent to total positions on worksheet
    # @param [Array] busy_position Array equivalent to only busy positions on worksheet
    # @param [Array] nursing_position Array equivalent to nursing beds on worksheet
    def create_result(bed_type, total_position, busy_position, nursing_position)
      total = @worksheet[*total_position]
      busy = @worksheet[*busy_position]
      nursing = @worksheet[*nursing_position].to_i

      (total.to_i - busy.to_i).times do |i|
        results << create_object(bed_type, :free, i)
      end

      busy.to_i.times do |i|
        ventilator = nursing > i
        results << create_object(bed_type, :busy, i, ventilator: ventilator)
      end
    end

    # Creates a internal object for using on beds instances creation
    # @param [Integer] bed_type Enum for bed_type
    # @param [Symbol] status Enum for status
    # @param [Integer] iterator
    # @return [DataBridge::InternalObject]
    def create_object(bed_type, status, iterator, ventilator: false)
      DataBridge::InternalObject.new(
        hospital_slug: hospital.slug,
        status: status,
        bed_type: bed_type,
        slug: generate_slug(bed_type, status, iterator),
        using_ventilator: ventilator
      )
    end

    private

    # Generates a slug for a bed
    # @param [Integer] bed_type Enum for bed_type
    # @param [Symbol] status Enum for status
    # @param [Integer] iterator
    # @return [String]
    def generate_slug(bed_type, status, iterator)
      "#{hospital.slug}-#{bed_type}-#{status}-#{iterator}"
    end

    # It's the same thing as usual send, but warns the developer in case he miss the method creation
    # Might be useless, but since it's a class that might be used for a lot of cities, and might be
    # used as another class' superclass, this method might help to abstract this class and debug
    # @param [Symbol] symbol A method's name
    # @return [Object]
    def hard_send(symbol)
      begin
        send_method = method(symbol)
      rescue NameError => e
        raise NotImplementedError, I18n.t('activerecord.passive_errors.method_not_defined', method: e.name)
      end
      send_method.call
    end

    # @return [Hash]
    def retrieve_credentials
      credentials = Rails.application.credentials.send("#{city.slug}_spreadsheet_key")
      return credentials if credentials

      raise NotImplementedError, CREDENTIALS_NOT_FOUND_MESSAGE
    end

    # @return [Hospital]
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
