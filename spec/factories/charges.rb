require 'faker'

FactoryGirl.define do
  factory :charge do |f|
    f.jms_charge_id "12345"
    f.booking_id "98765"
    f.code "02015"
    f.description "theft"
    f.category "misdemeanor"
    f.court_case_number "13579-ABC"
  end
end
