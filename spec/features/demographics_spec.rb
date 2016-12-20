require 'rails_helper'

describe 'demographics' do
  include ActionView::Helpers::NumberHelper

  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows gender breakdown of actively booked people', :js do
    male = FactoryGirl.create(:person, gender: 'male')
    female = FactoryGirl.create(:person, gender: 'female')
    released = FactoryGirl.create(:person, gender: 'female')

    FactoryGirl.create(:booking, person: male)
    FactoryGirl.create(:booking, person: female)
    FactoryGirl.create(:booking, :inactive, person: released)

    visit '/'

    within('.filters') do
      expect(page).to have_css('tr', text: 'male 1 50%')
      expect(page).to have_css('tr', text: 'female 1 50%')
    end
  end

  it 'shows race/ethnicity breakdown of actively booked people', :js do
    Person::RACES.each do |race|
      active = FactoryGirl.create(:person, race: race)
      FactoryGirl.create(:booking, person: active)

      inactive = FactoryGirl.create(:person, race: race)
      FactoryGirl.create(:booking, :inactive, person: inactive)
    end

    visit '/'

    expected_percentage = number_to_percentage(
      100.0 / Person::RACES.count,
      precision: 0,
    )
    within('.filters') do
      Person::RACES.each do |race|
        expect(page).to have_css('tr', text: "#{race} 1 #{expected_percentage}")
      end
    end
  end
end
