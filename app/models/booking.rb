class Booking < ActiveRecord::Base
  MULTIPLE_ACTIVE_BOOKINGS_ERROR =
    'must be present for all but a single active booking per person'.freeze

  self.primary_key = :jms_booking_id
  belongs_to :person, :foreign_key => :person_id, :primary_key => :jms_person_id
  has_many :charges, :foreign_key => :booking_id, :primary_key => :jms_booking_id

  validates :person_id, presence: true
  validates :jms_booking_id, presence: true, uniqueness: true

  PRE_TRIAL = 'Pre-trial'.freeze
  SENTENCED = 'Sentenced'.freeze
  BOND_CAP = 500

  scope :active, -> { where(release_date_time: nil) }
  scope :inactive, -> { where.not(release_date_time: nil) }
  scope :last_week, -> { where('booking_date_time > ?', 1.week.ago) }
  scope :bondable, -> { joins(:charges).merge(Charge.bondable).uniq }

  validate :only_one_active_booking

  def only_one_active_booking
    if person && (person.bookings.active - [self]).any?
      errors.add(:release_date_time, MULTIPLE_ACTIVE_BOOKINGS_ERROR)
    end
  end

  def bond_total
    charges.map { |c| c.bond_amount || 0 }.reduce(:+) || 0
  end

  def bondable?
    bond_total > 0
  end

  def released?
    release_date_time.present? && release_date_time < DateTime.now
  end
end
