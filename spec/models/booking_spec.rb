require 'rails_helper'

RSpec.describe Booking, type: :model do
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
      FactoryGirl.create(:booking, booking_date_time: DateTime.now - 8.days)

      FactoryGirl.create(:booking, booking_date_time: (DateTime.now - 1.week) + 1.hour)
      FactoryGirl.create(:booking, booking_date_time: DateTime.now - 6.days)

      expect(Booking.last_week.count).to eq(2)
    end
  end

  # it "is invalid without a person id" do
  #   FactoryGirl.create(:booking, person_id: nil).should_not be_valid
  # end
end
