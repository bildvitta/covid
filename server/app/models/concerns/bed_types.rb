# frozen_string_literal: true

module BedTypes
  extend ActiveSupport::Concern

  included do
    scope :icus, -> { where(bed_type: icu_types) }
    scope :nursings, -> { where(bed_type: nursing_types) }
    scope :covids, -> { where(bed_type: covid_types) }
    scope :normals, -> { where(bed_type: normal_types) }

    def self.icu_types
      [1, 2]
    end
  
    def self.nursing_types
      [3, 4]
    end
  
    def self.covid_types
      [1, 3]
    end
  
    def self.normal_types
      [2, 4]
    end
  end

  def icu?
    Bed.icu_types.include?(bed_type)
  end

  def nursing?
    Bed.nursing_types.include?(bed_type)
  end

  def covid?
    Bed.covid_types.include?(bed_type)
  end

  def normal?
    Bed.normal_types.include?(bed_type)
  end
end
