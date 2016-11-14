require 'faker'

FactoryGirl.define do
  factory :person do |f|
    f.jms_id "11235"
    f.first_name Faker::Name.first_name
    f.middle_name Faker::Name.first_name
    f.last_name Faker::Name.last_name
    f.date_of_birth Faker::Time.between(DateTime.now - 1, DateTime.now)
    f.gender "male"
    f.race "white"
  end
end
