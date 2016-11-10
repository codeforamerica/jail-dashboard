require 'spec_helper'
require 'rails_helper'

describe Bond do
  it "has a valid factory" do
    FactoryGirl.create(:bond).should be_valid
  end
  # it "is invalid without a charge id" do
  #   FactoryGirl.create(:bond, charge_id: nil).should be_invalid
  # end
end
