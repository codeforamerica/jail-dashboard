require 'rails_helper'

describe 'processing status' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows active pre-trial & sentenced population counts and percentages' do
    FactoryGirl.create(:booking, :inactive, status: Booking::PRE_TRIAL)

    FactoryGirl.create_list(:booking, 2, status: Booking::PRE_TRIAL)
    FactoryGirl.create(:booking, status: Booking::SENTENCED)

    visit '/'

    within('.processing-status') do
      expect(page).to have_css('tr', text: 'Pre-trial 2 66.7%')
      expect(page).to have_css('tr', text: 'Sentenced 1 33.3%')
    end
  end
end
