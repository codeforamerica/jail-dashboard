require 'faker'

FactoryGirl.define do
  factory :booking do |f|
    f.jms_id "98765"
    f.booking_date_time
    f.release_date_time
    f.first_name { Faker::Name.first_name }
    f.middle_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.date_of_birth
    f.gender "male"
    f.race "white"
    f.inmate_number "24601"
    f.facility_name "chateau d'if"
    f.cell_id "226"
    f.status "pre-trial"
  end
end
