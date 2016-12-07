require 'rails_helper'

describe 'processing status' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows active pre-trial population count and percentage', js: true do
    FactoryGirl.create_list(:booking, 2, status: Booking::PRE_TRIAL)
    FactoryGirl.create(:booking, :inactive, status: Booking::PRE_TRIAL)

    FactoryGirl.create(:booking, status: Booking::SENTENCED)

    visit '/'

    pre_trial_stats = page.find('.processing-status .pre-trial').text

    expect(pre_trial_stats).to include('2')
    expect(pre_trial_stats).to include('66.7%')
  end

  it 'shows active sentenced population count and percentage', js: true do
    FactoryGirl.create(:booking, status: Booking::SENTENCED)
    FactoryGirl.create(:booking, :inactive, status: Booking::SENTENCED)

    FactoryGirl.create_list(:booking, 2, status: Booking::PRE_TRIAL)

    visit '/'

    sentenced_stats = page.find('.processing-status .sentenced').text

    expect(sentenced_stats).to include('1')
    expect(sentenced_stats).to include('33.3%')
  end
end
