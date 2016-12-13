class Booking < ActiveRecord::Base
  MULTIPLE_ACTIVE_BOOKINGS_ERROR =
    'cannot create two active bookings for a single person'.freeze

  self.primary_key = :jms_booking_id
  belongs_to :person, :foreign_key => :person_id, :primary_key => :jms_person_id
  has_many :charges, :foreign_key => :booking_id, :primary_key => :jms_booking_id

  validates :person_id, presence: true
  validates :jms_booking_id, presence: true, uniqueness: true

  PRE_TRIAL = 'Pre-trial'.freeze
  SENTENCED = 'Sentenced'.freeze

  scope :active, -> { where(release_date_time: nil) }
  scope :inactive, -> { where.not(release_date_time: nil) }
  scope :last_week, -> { where('booking_date_time > ?', 1.week.ago) }

  validate :only_one_active_booking

  def only_one_active_booking
    if person && person.bookings.active.where.not(id: id).any?
      errors.add(:release_date_time, MULTIPLE_ACTIVE_BOOKINGS_ERROR)
    end
  end
end

