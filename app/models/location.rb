class Location < ApplicationRecord
  validates :name, :address, :appointment_url, presence: true
  has_many :appointments, dependent: :destroy

  enum location_type: {
    medidcal_center: 1,
    super_station: 2,
    community_center: 3,
    pharmacy: 4,
  }
end
