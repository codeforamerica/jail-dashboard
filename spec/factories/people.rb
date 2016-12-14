require 'faker'

FactoryGirl.define do
  factory :person do
    sequence(:jms_person_id) { |n| format('%05d', n) }
    first_name Faker::Name.first_name
    middle_name Faker::Name.first_name
    last_name Faker::Name.last_name
    date_of_birth Faker::Time.between(DateTime.now - 1, DateTime.now)
    gender Person::GENDERS.first
    race Person::RACES.first
  end

  trait :with_booking do
    after(:create) do |person|
      create :booking, person: person
    end
  end
end
