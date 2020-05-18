class BedState < ApplicationRecord
  enum status: { free: 1, busy: 2, unavailable: 3 }
end
