require 'faker'

FactoryGirl.define do
  factory :booking do
    sequence(:jms_booking_id) { |n| sprintf("%5d", n) }
    person_id "11235"
    booking_date_time Faker::Time.backward(365)
    release_date_time nil
    inmate_number "24601"
    facility_name "chateau d'if"
    cell_id "226"
    status "pre-trial"
    
    trait :inactive do
    	release_date_time Faker::Time.backward(360)
    end
  end
end
