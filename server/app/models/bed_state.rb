class BedState < ApplicationRecord
  belongs_to :hospital

  has_many :details, class_name: 'BedStateDetail', foreign_key: :bed_state_id, dependent: :destroy

  validates_uniqueness_of :date, scope: :hospital_id
end
