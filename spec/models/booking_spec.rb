require 'rails_helper'

RSpec.describe Booking do
  describe 'factory traits' do
    specify { FactoryGirl.create(:booking).should be_valid }

    specify { FactoryGirl.create(:booking, :inactive).should be_valid }

    specify { FactoryGirl.create(:booking, :last_week).should be_valid }
  end

  describe 'validations' do
    it 'does not allow multiple active bookings for a single person' do
      original_booking = FactoryGirl.create(:booking)
      new_booking = FactoryGirl.build(:booking, person: original_booking.person)

      expect(new_booking).not_to be_valid
      expect(new_booking.errors[:release_date_time]).
        to include(Booking::MULTIPLE_ACTIVE_BOOKINGS_ERROR)
    end

    it "is invalid without a person id" do
      booking = FactoryGirl.build(:booking, person_id: nil)

      expect(booking).not_to be_valid
    end
  end

  describe 'scopes' do
    it 'should return active bookings' do
      FactoryGirl.create(:booking)
      FactoryGirl.create(:booking, :inactive)

      expect(Booking.active.count).to eq(1)
    end

    it 'should return inactive bookings' do
      FactoryGirl.create(:booking)
      FactoryGirl.create(:booking, :inactive)

      expect(Booking.inactive.count).to eq(1)
    end

    it 'should return all bookings in last week' do
      FactoryGirl.create(:booking, booking_date_time: 8.days.ago)

      FactoryGirl.create(:booking, booking_date_time: 1.week.ago + 1.hour)
      FactoryGirl.create(:booking, booking_date_time: 6.days.ago)

      expect(Booking.last_week.count).to eq(2)
    end
  end
end
