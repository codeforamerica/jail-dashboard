require 'rails_helper'

RSpec.describe Booking, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:booking)).to be_valid
  end

  describe 'scopes' do
  	it 'should return active bookings' do
  		FactoryGirl.create(:booking)
  		FactoryGirl.create(:booking, :inactive)

  		expect(Booking.active.count).to eq(1)
  	end
  end

  # it "is invalid without a person id" do
  #   FactoryGirl.create(:booking, person_id: nil).should_not be_valid
  # end
end
