# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_12_073618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.date "date", null: false
    t.time "start_time"
    t.time "end_time"
    t.integer "vaccines_available"
    t.bigint "location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_appointments_on_date"
    t.index ["location_id"], name: "index_appointments_on_location_id"
  end

  create_table "geographies", force: :cascade do |t|
    t.string "state", null: false
    t.string "county", null: false
    t.string "city", null: false
    t.string "neighborhood"
    t.string "postal_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city"
    t.boolean "is_active", default: true
    t.boolean "is_walk_thru", default: false
    t.boolean "is_drive_thru", default: false
    t.string "appointment_url", null: false
    t.string "managed_by"
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false
    t.integer "location_type"
  end

  add_foreign_key "appointments", "locations"
end
