# frozen_string_literal: true

module BedTypes
  extend ActiveSupport::Concern

  included do
    scope :icus, -> { where(bed_type: icu_types) }
    scope :nursings, -> { where(bed_type: nursing_types) }
    scope :covids, -> { where(bed_type: covid_types) }
    scope :normals, -> { where(bed_type: normal_types) }
    scope :extras, -> { where(bed_type: extra_types) }

    def self.icu_types
      [1, 2, 5]
    end
  
    def self.nursing_types
      [3, 4, 6]
    end
  
    def self.covid_types
      [1, 3, 5, 6]
    end
  
    def self.normal_types
      [2, 4]
    end

    def self.extra_types
      [5, 6]
    end
  end

  def icu?
    self.class.icu_types.include?(bed_type)
  end

  def nursing?
    self.class.nursing_types.include?(bed_type)
  end

  def covid?
    self.class.covid_types.include?(bed_type)
  end

  def normal?
    self.class.normal_types.include?(bed_type)
  end

  def extra?
    self.class.extra_types.include?(bed_type)
  end
end
