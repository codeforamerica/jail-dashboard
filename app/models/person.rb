class Person < ActiveRecord::Base
  self.primary_key = :jms_id
    has_many :bookings, :foreign_key => :person_id, :primary_key => :jms_id
end
