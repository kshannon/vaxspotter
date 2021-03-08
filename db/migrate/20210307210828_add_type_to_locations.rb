class AddTypeToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :location_type, :integer, null: false
  end
end
