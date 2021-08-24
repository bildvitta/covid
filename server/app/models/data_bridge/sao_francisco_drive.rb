# frozen_string_literal: true

module DataBridge
  # Sao Francisco integration sheet based
  class SaoFranciscoDrive < GenericCityDrive
    # @param [Symbol, Array] to_do It can be :beds, :cases or both on array
    def initialize(to_do: TO_DO_TYPES)
      super(City.find_by_slug('ribeirao-preto'), to_do: to_do)
    end

    private

    # @return [Hash]
    def retrieve_credentials
      Rails.application.credentials.sao_francisco_spreadsheet_key
    end

    # @return [Hospital]
    def retrieve_hospital
      @retrieve_hospital ||= Hospital.find_by_slug('hospital-sao-francisco')
    end

    # Generates a slug for a bed
    # @param [Integer] bed_type Enum for bed_type
    # @param [Symbol] status Enum for status
    # @param [Integer] iterator
    # @return [String]
    def generate_slug(bed_type, status, iterator)
      "sf-#{bed_type}-#{status}-#{iterator}"
    end
  end
end
