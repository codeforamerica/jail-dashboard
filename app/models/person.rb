class Person < ActiveRecord::Base
  GENDERS = %w{male female}.map!(&:freeze).freeze
  RACES = [
    'Alaska Native',
    'American Indian',
    'Asian',
    'White',
    'Black or African American',
    'Hispanic',
    'Middle Eastern',
  ].map!(&:freeze).freeze

  self.primary_key = :jms_person_id
  has_many :bookings, foreign_key: :person_id, primary_key: :jms_person_id

  validates :jms_person_id, presence: true, uniqueness: true

  scope :active, -> { joins(:bookings).merge(Booking.active).uniq }

  def active_booking
    bookings.active.sort{|b1, b2| b1.booking_date_time <=> b2.booking_date_time }.last
  end

  def self.target_bondable
    target_bondable_people = Person.active.select do |p|
      p.active_booking.bondable? && p.active_booking.bond_total <= Booking::BOND_CAP
    end
    target_bondable_people.sort do |p1, p2|
      p1.active_booking.bond_total <=> p2.active_booking.bond_total
    end
  end
end
