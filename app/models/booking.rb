class Booking < ActiveRecord::Base
  self.primary_key = :jms_id
  belongs_to :person, :foreign_key => :person_id, :primary_key => :jms_id
  has_many :charges, :foreign_key => :booking_id, :primary_key => :jms_id

  validates :person_id, presence: true

end
