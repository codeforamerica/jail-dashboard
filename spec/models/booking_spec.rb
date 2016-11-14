require 'rails_helper'

RSpec.describe Booking, type: :model do
  it "has a valid factory" do
    FactoryGirl.create(:booking).should be_valid
  end
  # it "is invalid without a person id" do
  #   FactoryGirl.create(:booking, person_id: nil).should_not be_valid
  # end
end
