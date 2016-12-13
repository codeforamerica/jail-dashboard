require 'faker'

FactoryGirl.define do
  factory :charge do
    jms_charge_id "12345"
    booking_id "98765"
    code "02015"
    description "theft"
    category "misdemeanor"
    court_case_number "13579-ABC"
    bond_amount 250.00
  end

  trait :unbondable do
    bond_amount nil
  end
end
