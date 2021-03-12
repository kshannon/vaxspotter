class CreateGeography < ActiveRecord::Migration[6.1]
  def change
    create_table :geographies do |t|
      t.string :state, null: false
      t.string :county, null: false
      t.string :city, null:false
      t.string :neighborhood
      t.string :postal_code, null: false, unique: true

      t.timestamps
    end
  end
end