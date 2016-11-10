namespace :bookings do
  desc "import bookings data from flat file"
  task import: :environment do
    require 'csv'

    Booking.transaction do
      puts "reading bookings"
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      bookings = CSV.read("#{Rails.root}/tmp/bookings.csv")
      columns = [:jms_id, :booking_date_time, :release_date_time, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :race, :inmate_number, :facility_name, :cell_id, :status]
      Booking.import columns, bookings, validate: false
      puts "bookings imported"
    end
  end
end
