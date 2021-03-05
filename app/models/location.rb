class Location < ApplicationRecord
  validates :name, :address, :appointment_url, presence: true
end
