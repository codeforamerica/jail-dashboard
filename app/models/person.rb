class Person < ActiveRecord::Base
    has_many :bookings, :foreign_key => :person_id, :primary_key => :jms_id
end
