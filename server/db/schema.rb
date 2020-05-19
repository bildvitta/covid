# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_18_213942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bed_state_details", force: :cascade do |t|
    t.boolean "using_ventilator", default: false
    t.integer "bed_state_id"
    t.integer "bed_type", default: 1
    t.integer "status_free", default: 0
    t.integer "status_busy", default: 0
    t.integer "status_unavailable", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bed_state_id"], name: "index_bed_state_details_on_bed_state_id"
  end

  create_table "bed_states", force: :cascade do |t|
    t.integer "hospital_id"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hospital_id"], name: "index_bed_states_on_hospital_id"
  end

  create_table "beds", force: :cascade do |t|
    t.integer "hospital_id"
    t.integer "status", default: 1
    t.integer "bed_type", default: 1
    t.string "slug"
    t.boolean "using_ventilator", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hospital_id"], name: "index_beds_on_hospital_id"
    t.index ["slug"], name: "index_beds_on_slug"
  end

  create_table "cities", force: :cascade do |t|
    t.integer "state_id"
    t.string "name"
    t.string "slug"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["latitude"], name: "index_cities_on_latitude"
    t.index ["longitude"], name: "index_cities_on_longitude"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "covid_cases", force: :cascade do |t|
    t.integer "city_id"
    t.integer "total", default: 0
    t.integer "deaths", default: 0
    t.integer "cureds", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_covid_cases_on_city_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.integer "city_id"
    t.integer "hospital_type", default: 1
    t.string "name"
    t.string "slug"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_hospitals_on_city_id"
    t.index ["latitude"], name: "index_hospitals_on_latitude"
    t.index ["longitude"], name: "index_hospitals_on_longitude"
    t.index ["slug"], name: "index_hospitals_on_slug"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "prefix"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_states_on_slug"
  end

end
