require 'rails_helper'

describe Person do
  it 'has a valid factory' do
    FactoryGirl.create(:person).should be_valid
  end
end
