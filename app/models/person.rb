class Person < ActiveRecord::Base
  RACES = [
    'Alaska Native',
    'American Indian',
    'Asian',
    'White',
    'Black or African American',
    'Hispanic',
    'Middle Eastern',
  ].freeze

  self.primary_key = :jms_person_id
  has_many :bookings, foreign_key: :person_id, primary_key: :jms_person_id

  GENDERS = %w{male female}
  RACES = [
    'white',
    'black',
    'hispanic',
    'asian or pacific islander',
    'american indian or alaskan native'
  ]
end
