require 'rails_helper'

RSpec.describe Person, type: :model do
  it "has a valid factory" do
    FactoryGirl.create(:person).should be_valid
  end
end
