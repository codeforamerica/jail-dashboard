class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :jms_id
      t.datetime :booking_date_time
      t.datetime :release_date_time
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.datetime :date_of_birth
      t.string  :gender
      t.string  :race
      t.string  :inmate_number
      t.string  :facility_name
      t.string  :cell_id
      t.string  :status
      t.timestamps null: false
    end
  end
end
