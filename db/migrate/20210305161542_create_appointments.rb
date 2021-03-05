class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.date :date, null: false
      t.time :start_time
      t.time :end_time
      t.integer :vaccines_available
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
    add_index(:appointments, :date)
    add_column(:locations, :archived, :boolean, default: false)
  end
end
