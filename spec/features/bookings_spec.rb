require 'rails_helper'

describe 'bookings data' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows count of current and inactive bookings from past week' do
    FactoryGirl.create(:booking)
    FactoryGirl.create_list(:booking, 2, :last_week)
    FactoryGirl.create_list(:booking, 2, :last_week, :inactive)

    visit '/'

    booked_current_week = page.find('.booking-stats .current-week-booked').text

    expect(booked_current_week).to eq('4 people booked within past week')
  end

  it 'shows count of people released on bond in past week' do
    FactoryGirl.create_list(:booking, 2)
    FactoryGirl.create_list(:booking, 2, :last_week)
    FactoryGirl.create_list(:booking, 1, :last_week, :inactive)

    visit '/'

    booked_current_week = page.find('.booking-stats .current-week-released').text

    expect(booked_current_week).to eq('1 (33.3%) people released')
  end
end
