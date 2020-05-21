module DataBridge
  class Base
    attr_accessor :raw_data, :data, :results

    def save!
      hospitals = {}

      self.results.each do |r|
        unless hospitals.has_key?(r.hospital_slug)
          hospitals[r.hospital_slug] = Hospital.where(slug: r.hospital_slug).first.try(:id)
        end

        next if hospitals[r.hospital_slug].nil?

        Bed.where(hospital_id: hospitals[r.hospital_slug], slug: r.slug).first_or_create do |bed|
          bed.status = r.status
          bed.bed_type = r.bed_type
          bed.using_ventilator = r.using_ventilator
        end
      end
      # apagar as q nao vieram

      return self
    end

    def get_bed_type bed_type
      case bed_type.to_s.strip.downcase
      when 'uti-covid'
        return 1
      when 'uti-nao-covid'
        return 2
      when 'enfermaria-covid'
        return 3
      when 'enfermaria-nao-covid'
        return 4
      else
        return 0
      end
    end

    def get_status status
      case status.to_s.downcase.strip.to_sym
      when :livre
        return :free
      when :ocupado
        return :busy
      else
        return :unavailable
      end
    end

  end
end
