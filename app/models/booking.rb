class Booking < ActiveRecord::Base
  has_many :charges, :foreign_key => :booking_id, :primary_key => :jms_id
end
