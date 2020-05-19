class BedState < ApplicationRecord
  has_many :details, class_name: 'BedStateDetail', foreign_key: :bed_state_id
end
