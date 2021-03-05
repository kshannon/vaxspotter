class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city
      t.boolean :is_active, default: true
      t.boolean :is_walk_thru, default: false
      t.boolean :is_drive_thru, default: false
      t.string :appointment_url, null: false
      t.string :managed_by
      t.string :contact_email
      t.string :contact_phone

      t.timestamps
    end
  end
end
