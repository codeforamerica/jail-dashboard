require 'faker'

FactoryGirl.define do
  factory :booking do |f|
    f.jms_booking_id "98765"
    f.person_id "11235"
    f.booking_date_time Faker::Time.backward(365)
    f.release_date_time Faker::Time.backward(360)
    f.inmate_number "24601"
    f.facility_name "chateau d'if"
    f.cell_id "226"
    f.status "pre-trial"
  end
end
