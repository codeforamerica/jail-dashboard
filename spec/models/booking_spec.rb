require 'rails_helper'

describe Booking, type: :model do
  describe 'factory and traits' do
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

    it 'is invalid without a person id' do
      booking = FactoryGirl.build(:booking, person_id: nil)

      expect(booking).not_to be_valid
    end
  end

  describe 'scopes' do
    describe '.active' do
      it 'should return active bookings' do
        FactoryGirl.create(:booking)
        FactoryGirl.create(:booking, :inactive)

        expect(Booking.active.count).to eq(1)
      end
    end

    describe '.inactive' do
      it 'should return inactive bookings' do
        FactoryGirl.create(:booking)
        FactoryGirl.create(:booking, :inactive)

        expect(Booking.inactive.count).to eq(1)
      end
    end

    describe '.last_week' do
      it 'should return all bookings in last week' do
        FactoryGirl.create(:booking, booking_date_time: 8.days.ago)

        FactoryGirl.create(:booking, booking_date_time: 1.week.ago + 1.hour)
        FactoryGirl.create(:booking, booking_date_time: 6.days.ago)

        expect(Booking.last_week.count).to eq(2)
      end
    end

    describe '.bondable' do
      it 'should return bookings with bondable charges' do
        bondable_booking = FactoryGirl.create(:booking)
        FactoryGirl.create(:charge, booking: bondable_booking)

        unbondable_booking = FactoryGirl.create(:booking)
        FactoryGirl.create(:charge, :unbondable, booking: unbondable_booking)

        expect(Booking.bondable.count).to eq(1)
        expect(Booking.bondable.first).to eq(bondable_booking)
      end

      it 'should only return booking once for multiple bondable charges' do
        bondable_booking = FactoryGirl.create(:booking)
        FactoryGirl.create(:charge, booking: bondable_booking)
        FactoryGirl.create(:charge, booking: bondable_booking)

        expect(Booking.bondable.count).to eq(1)
        expect(Booking.bondable.first).to eq(bondable_booking)
      end
    end
  end

  describe 'bond_total' do
    it 'returns sum of bond amounts for its charges' do
      booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: booking, bond_amount: 10.0)
      FactoryGirl.create(:charge, booking: booking, bond_amount: 20.0)

      expect(booking.bond_total).to eq(30.0)
    end

    it 'gracefully handles nil bond amounts' do
      booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: booking, bond_amount: nil)
      FactoryGirl.create(:charge, booking: booking, bond_amount: 20.0)

      expect(booking.bond_total).to eq(20.0)
    end

    it 'returns 0 if no charges present' do
      booking = FactoryGirl.create(:booking)

      expect(booking.bond_total).to eq(0)
    end
  end

  describe 'bondable?' do
    it 'returns true if bond_total is over 0' do
      booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: booking, bond_amount: 10.0)

      expect(booking.bondable?).to eq(true)
    end

    it 'returns false if bond_total is 0' do
      booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: booking, bond_amount: 0)

      expect(booking.bondable?).to eq(false)
    end

    it 'returns false if bond_total is nil' do
      booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: booking, bond_amount: nil)

      expect(booking.bondable?).to eq(false)
    end
  end

  describe 'released?' do
    it 'returns true if release_date_time is present and before current time' do
      booking = FactoryGirl.create(:booking, release_date_time: 1.day.ago)

      expect(booking.released?).to eq(true)
    end

    it 'returns false if release_date_time is after current time' do
      booking = FactoryGirl.create(:booking, release_date_time: 1.day.from_now)

      expect(booking.released?).to eq(false)
    end

    it 'returns false if release_date_time not present' do
      booking = FactoryGirl.create(:booking, release_date_time: nil)

      expect(booking.released?).to eq(false)
    end
  end
end
