require 'rails_helper'

describe 'bookings data' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows count of current and inactive bookings from past week' do
    FactoryGirl.create_list(:booking, 2)
    FactoryGirl.create_list(:booking, 2, :last_week)
    FactoryGirl.create_list(:booking, 1, :last_week, :inactive)

    visit '/'

    within('.booking-stats') do
      expect(page).to have_css('tr', text: '3 people booked within past week')
      expect(page).to have_css('tr', text: '1 (25.0%) people released')
    end
  end
end
