FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password 'password'
    role User::ROLES.second

    trait :admin do
      role User::ROLES.first
    end
  end
end
