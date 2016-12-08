require 'rails_helper'

describe 'bookings data' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows count of current and inactive bookings from past week', js: true do
    FactoryGirl.create(:booking)
    FactoryGirl.create_list(:booking, 2, :last_week)
    FactoryGirl.create_list(:booking, 2, :last_week, :inactive)

    visit '/'

    booked_current_week = page.find('.booking-stats .current-week').text

    expect(booked_current_week).to eq('4 people booked within past week')
  end
end
