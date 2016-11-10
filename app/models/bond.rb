class Bond < ActiveRecord::Base
  belongs_to :charge, :foreign_key => :charge_id, :primary_key => :jms_id

  validates :charge_id, presence: true
end
