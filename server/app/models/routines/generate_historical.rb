class Routines::GenerateHistorical
  attr_accessor :date

  def initialize date = Date.today
    self.date = date
  end

  def run!
    BedState.transaction do
      Hospital.all.each(&method(:create_bed_state!))
    end
  end

  def create_bed_state! hospital
    bed_count = hospital.beds.group(:using_ventilator, :status, :bed_type).count
    bed_state = BedState.find_or_create_by(date: date, hospital: hospital)

    bed_state.details.destroy_all

    [true, false].each do |using_ventilator|
      Bed::TYPES.each do |_label, value|
        get_status = -> (status) { bed_count[[using_ventilator, status, value]] || 0 }

        bed_state.details.create!(
          using_ventilator: using_ventilator,
          bed_type: value,

          status_free: get_status.('free'),
          status_busy: get_status.('busy'),
          status_unavailable: get_status.('unavailable')
        )
      end
    end
  end

end