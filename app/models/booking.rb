class Booking < ActiveRecord::Base
  self.primary_key = :jms_booking_id
  belongs_to :person, :foreign_key => :person_id, :primary_key => :jms_person_id
  has_many :charges, :foreign_key => :booking_id, :primary_key => :jms_booking_id

  validates :person_id, presence: true

  PRE_TRIAL = 'Pre-trial'.freeze
  SENTENCED = 'Sentenced'.freeze

  scope :active, -> { where(release_date_time: nil) }
  scope :last_week, -> { where('booking_date_time > ?', 1.week.ago) }
end

