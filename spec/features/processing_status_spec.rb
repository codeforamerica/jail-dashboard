require 'rails_helper'

describe 'processing status' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows active population status counts and percentages', :js do
    FactoryGirl.create(:booking, :inactive, status: Booking::PRE_TRIAL)

    FactoryGirl.create_list(:booking, 2, status: Booking::PRE_TRIAL)
    FactoryGirl.create(:booking, status: Booking::SENTENCED)

    visit '/'

    within('.breakdown-table.status') do
      expect(page).to have_css('.breakdown-row', text: 'Pre-trial 2 67%')
      expect(page).to have_css('.breakdown-row', text: 'Sentenced 1 33%')
    end
  end
end
