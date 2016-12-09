require 'rails_helper'

describe 'location' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows location breakdown of active bookings' do
    FactoryGirl.create(:booking, facility_name: 'Azkaban')
    FactoryGirl.create(:booking, facility_name: 'Alcatraz')
    FactoryGirl.create(:booking, :inactive, facility_name: 'Alcatraz')

    visit '/'

    within('.location') do
      expect(page).to have_css('tr', text: 'Alcatraz 1 50.0%')
      expect(page).to have_css('tr', text: 'Azkaban 1 50.0%')
    end
  end
end
