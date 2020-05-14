class Hospital < ApplicationRecord
  TYPES = [['Público', 1], ['Privado', 2]]

  belongs_to :city

  has_many :beds

  accepts_nested_attributes_for :beds

  extend FriendlyId
  friendly_id :name, use: :slugged
end
