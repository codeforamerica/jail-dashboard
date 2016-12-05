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

ActiveRecord::Schema.define(version: 20161205160716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: true do |t|
    t.string   "jms_booking_id"
    t.datetime "booking_date_time"
    t.datetime "release_date_time"
    t.string   "inmate_number"
    t.string   "facility_name"
    t.string   "cell_id"
    t.string   "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "person_id"
  end

  create_table "charges", force: true do |t|
    t.string   "jms_charge_id"
    t.string   "booking_id"
    t.string   "code"
    t.string   "description"
    t.string   "category"
    t.string   "court_case_number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "bond_amount"
  end

  create_table "people", force: true do |t|
    t.string   "jms_person_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "date_of_birth"
    t.string   "gender"
    t.string   "race"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
