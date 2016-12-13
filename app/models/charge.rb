class Charge < ActiveRecord::Base
  self.primary_key = :jms_charge_id
  belongs_to :booking, :foreign_key => :booking_id, :primary_key => :jms_booking_id

  validates :jms_charge_id, presence: true, uniqueness: true
  validates :booking_id, presence: true
end
