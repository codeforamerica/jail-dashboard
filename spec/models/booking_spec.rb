require 'rails_helper'

describe Booking, type: :model do
  it 'has valid factory and traits' do
    expect(FactoryGirl.create(:booking)).to be_valid
    expect(FactoryGirl.create(:booking, :inactive)).to be_valid
    expect(FactoryGirl.create(:booking, :last_week)).to be_valid
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

    it 'should return bookings with bondable charges' do
      bondable_booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, booking: bondable_booking)

      unbondable_booking = FactoryGirl.create(:booking)
      FactoryGirl.create(:charge, :unbondable, booking: unbondable_booking)

      expect(Booking.bondable.count).to eq(1)
      expect(Booking.bondable.first).to eq(bondable_booking)
    end
  end

  describe 'bond_total' do
    it 'returns sum of bond amounts for charges' do
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

  # it "is invalid without a person id" do
  #   FactoryGirl.create(:booking, person_id: nil).should_not be_valid
  # end
end
