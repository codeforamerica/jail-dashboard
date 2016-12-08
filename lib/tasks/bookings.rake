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

    puts "Generating #{count} bookings within last week"
    Booking.transaction do
      people = Person.last(count)
      facilities = ['Main Jail Complex', 'Medical Facility', 'County Correctional Center']

      count.times do |index|
        booking_date_time = Faker::Time.between(1.week.ago, DateTime.now)
        Booking.create!(
          jms_booking_id: Faker::Code.ean,
          booking_date_time: booking_date_time,
          release_date_time: [booking_date_time, nil].sample,
          inmate_number: Faker::Number.hexadecimal(10),
          facility_name: facilities.sample,
          cell_id: Faker::Address.building_number,
          status: [Booking::PRE_TRIAL, Booking::SENTENCED].sample,
          person_id: people[index].jms_person_id
        )
      end
    end

    puts "Successfully generated #{count} bookings within last week"
  end
end
