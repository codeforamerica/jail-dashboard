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

  scope :active, -> { joins(:bookings).merge(Booking.active) }
  scope :bondable, -> { joins(:bookings).merge(Booking.bondable) }

  def active_booking
    bookings.active.first
  end
end
