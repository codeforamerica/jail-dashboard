require 'faker'

FactoryGirl.define do
  factory :bond do |f|
    f.charge_id "12345"
    f.amount 250.00
  end
end
