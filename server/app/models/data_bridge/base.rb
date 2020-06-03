module DataBridge
  class Base
    attr_accessor :raw_data, :data, :results

    def save!
      hospitals = Hospital.where(slug: self.results.map{ |r| r.hospital_slug }.uniq).map{ |h| [h.hospital_slug, h.id] }.to_h
      Bed.where(hospital_id: hospitals.values).destroy_all

      self.results.each do |r|
        next if hospitals[r.hospital_slug].nil?

        bed = Bed.where(hospital_id: hospitals[r.hospital_slug], slug: r.slug).first_or_create do |bed|
          bed.status = r.status
          bed.bed_type = r.bed_type
          bed.using_ventilator = r.using_ventilator
          bed.updated_at = Time.now
        end

        # melhorar
        bed.status = r.status
        bed.bed_type = r.bed_type
        bed.using_ventilator = r.using_ventilator
        bed.updated_at = Time.now

        bed.save
      end

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
