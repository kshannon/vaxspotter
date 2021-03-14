class UpdateLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :postal_code, :string
    add_column :locations, :longitude, :string
    add_column :locations, :latitude, :string
    add_column :locations, :state, :string
    add_column :locations, :appointments_last_fetched, :datetime
    add_column :locations, :api_id, :bigint
  end
end
