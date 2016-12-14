namespace :bookings do
  desc 'import bookings data from flat file'
  task import: :environment do
    require 'csv'

    Booking.transaction do
      puts 'reading bookings'
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      bookings = CSV.read("#{Rails.root}/tmp/bookings.csv")
      columns = [:jms_booking_id, :person_id, :booking_date_time, :release_date_time, :inmate_number, :facility_name, :cell_id, :status]
      Booking.import columns, bookings, validate: false
      puts 'bookings imported'
    end
  end

  desc 'generate bookings within the last week'
  task :generate_weekly, [:count] => [:environment] do |_, args|
    count = (args[:count] || 10).to_i

    puts "Generating #{count} bookings within last week..."
    released_bookings = 0

    Booking.transaction do
      facilities = ['Main Jail Complex', 'Medical Facility', 'County Correctional Center']

      people = Person.order(:created_at).last(count)

      people.each_with_index do |person, index|
        if person.bookings.active.any?
          person.bookings.active.each do |booking|
            booking.release_date_time = DateTime.now
            booking.save

            released_bookings += 1
          end
        end

        booking_date_time = Faker::Time.between(6.days.ago, DateTime.now)
        Booking.create!(
          jms_booking_id: Faker::Code.ean,
          booking_date_time: booking_date_time,
          release_date_time: nil,
          inmate_number: Faker::Number.hexadecimal(10),
          facility_name: facilities.sample,
          cell_id: Faker::Address.building_number,
          status: [Booking::PRE_TRIAL, Booking::SENTENCED].sample,
          person_id: person.jms_person_id
        )
      end
    end

    puts "Successfully generated #{count} active bookings within the last week,"
    puts "  and released #{released_bookings} previously active bookings in the process."
  end
end
