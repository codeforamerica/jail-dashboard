require 'faker'

FactoryGirl.define do
  factory :charge do
    sequence(:jms_charge_id) { |n| format("%05d", n) }
    booking
    code "02015"
    description "theft"
    category "misdemeanor"
    court_case_number "13579-ABC"
    bond_amount 250.00
  end
end
