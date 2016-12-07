require "csv"
require "faker"
require "rails"

puts "generating fake data..."

@row_count = 800
@people = []
@bookings = []
@charges = []
@bonds = []

# Set pools of JMS IDs
@jms_people_ids = []
@jms_booking_ids = []
@jms_charge_ids = []

# Populate person rows
(0...@row_count).each do |r|
    row = []
    person = Faker::Code.isbn
    @jms_people_ids << person
    row << person
    row << Faker::Name.first_name
    row << Faker::Name.first_name
    row << Faker::Name.last_name
    row << Faker::Time.between(70.years.ago, 18.years.ago)
    row << ["Male", "Female"].sample
    row << ["White", "Black", "Hispanic", "Asian or Pacific Islander", "American Indian or Alaskan Native"].sample
    @people << row
end

# Build people.csv
CSV.open("people.csv", "wb") do |csv|
  @people.each do |row|
    csv << row
  end
end


# Populate booking rows
(0...@row_count).each do |r|
    booking = Faker::Code.ean
    @jms_booking_ids << booking
    booking_date = Faker::Time.between(2.years.ago, 1.day.ago)
    release_date = Faker::Time.between(booking_date, Time.now)
    row = []
    row << booking
    row << @jms_people_ids.sample
    row << booking_date
    row << [release_date, ""].sample
    row << Faker::Number.hexadecimal(10)
    row << ["Main Jail Complex", "Medical Facility", "County Correctional Center"].sample
    row << Faker::Address.building_number
    row << ["Pre-trial", "Sentenced"].sample
    @bookings << row
end

# Build bookings.csv
CSV.open("bookings.csv", "wb") do |csv|
  @bookings.each do |row|
    csv << row
  end
end


# Populate charge rows
(0...@row_count).each do |r|
    charge = Faker::Code.asin
    @jms_charge_ids << charge
    codes = ["42215","23301","02620","13162","10000","10060","52197","22061","02760","02668","02648","01600","49012","12002","00803","02304","38010","10993","00822","10001","49041","25019","42054","01402","09150","02617","02906","13201","13242","10002"]
    descriptions = ["DRUGS","THEFT","DUI","ASSAULT","GENERAL FELONY","KIDNAPPING","WEAPONS","BURGLARY","DV PROTECTIVE ORDER","PROBATION/PAROLE VIOLATION","CONTEMPT OF COURT","PROSTITUTION","FUGITIVE ESCAPE","ROBBERY","MENACING","ALCOHOL","FLAGRANT NON SUPPORT","RAPE","TERRORISTIC THREATS","OTHER","HINDERING/INTIMIDATING","FORGERY","FRAUD","NON-SUPPORT","MURDER","TRAFFIC","WARRANT","CHILD ENDANGERMENT","STALKING","TRESPASSING"]
    n = rand(0..29)
    row = []
    row << charge
    row << @jms_booking_ids.sample
    row << descriptions[n]
    row << codes[n]
    row << ["MISDEMEANOR","FELONY","VIOLATION","ORDINANCE","NON-CRIMINAL"].sample
    row << Faker::Number.hexadecimal(8)
    row << ["", 0.00, 100.00, 150.00, 250.00, 500.00, 750.00, 1000.00, 5000.00, 10000.00].sample
    @charges << row
end

# Build charges.csv
CSV.open("charges.csv", "wb") do |csv|
  @charges.each do |row|
    csv << row
  end
end

# # Populate bond rows
# (0...@row_count).each do |r|

#     row = []
#     row << @jms_charge_ids.sample
#     row << ["", 0.00, 100.00, 150.00, 250.00, 500.00, 750.00, 1000.00, 5000.00, 10000.00].sample
#     @bonds << row
# end

# # Build bonds.csv
# CSV.open("bonds.csv", "wb") do |csv|
#   @bonds.each do |row|
#     csv << row
#   end
# end

puts "...fake data generated"
