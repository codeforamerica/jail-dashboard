class Charge < ActiveRecord::Base
  belongs_to :booking, :foreign_key => :booking_id, :primary_key => :jms_id
  has_many :bonds, :foreign_key => :charge_id, :primary_key => :jms_id

  validates :booking_id, presence: true
end
