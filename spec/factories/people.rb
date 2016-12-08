require 'faker'

FactoryGirl.define do
  factory :person do
    sequence(:jms_person_id) { |n| (11235 + n).to_s }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    gender Person::GENDERS.first
    race Person::RACES.first
  end
end
