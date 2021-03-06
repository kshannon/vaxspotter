class Location < ApplicationRecord
  validates :name, :address, :appointment_url, presence: true
  has_many :appointments
end
