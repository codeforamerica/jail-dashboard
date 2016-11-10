require 'spec_helper'
require 'rails_helper'

describe Booking do
  it "has a valid factory" do
    FactoryGirl.create(:booking).should be_valid
  end
end
