# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161112010646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bonds", force: true do |t|
    t.string   "charge_id"
    t.float    "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: true do |t|
    t.string   "jms_id"
    t.datetime "booking_date_time"
    t.datetime "release_date_time"
    t.string   "inmate_number"
    t.string   "facility_name"
    t.string   "cell_id"
    t.string   "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "charges", force: true do |t|
    t.string   "jms_id"
    t.string   "booking_id"
    t.string   "code"
    t.string   "description"
    t.string   "category"
    t.string   "court_case_number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "people", force: true do |t|
    t.string   "jms_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "date_of_birth"
    t.string   "gender"
    t.string   "race"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
