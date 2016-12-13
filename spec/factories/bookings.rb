require 'faker'

FactoryGirl.define do
  factory :booking do
    sequence(:jms_booking_id) { |n| format('%05d', n) }
    person

    booking_date_time Faker::Time.backward(365)
    release_date_time nil
    inmate_number '24601'
    facility_name "chateau d'if"
    cell_id '226'
    status Booking::PRE_TRIAL

    trait :inactive do
      status Booking::SENTENCED
      release_date_time Faker::Time.backward(2)
    end

    trait :last_week do
      booking_date_time Faker::Time.backward(4)
    end
  end
end
