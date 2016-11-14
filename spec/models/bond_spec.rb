require 'rails_helper'

RSpec.describe Bond, type: :model do
  it "has a valid factory" do
    FactoryGirl.create(:bond).should be_valid
  end
  # it "is invalid without a charge id" do
  #   FactoryGirl.create(:bond, charge_id: nil).should_not be_valid
  # end
end
