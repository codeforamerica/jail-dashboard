require 'rails_helper'

describe 'demographics' do
  include ActionView::Helpers::NumberHelper

  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows gender breakdown of actively booked people' do
    male = FactoryGirl.create(:person, gender: 'male')
    female = FactoryGirl.create(:person, gender: 'female')
    released = FactoryGirl.create(:person, gender: 'female')

    FactoryGirl.create(:booking, person: male)
    FactoryGirl.create(:booking, person: female)
    FactoryGirl.create(:booking, :inactive, person: released)

    visit '/'

    within('.demographics-gender') do
      expect(page).to have_css('tr', text: 'male 1 50.0%')
      expect(page).to have_css('tr', text: 'female 1 50.0%')
    end
  end

  it 'shows race/ethnicity breakdown of actively booked people' do
    Person::RACES.each do |race|
      active = FactoryGirl.create(:person, race: race)
      FactoryGirl.create(:booking, person: active)

      inactive = FactoryGirl.create(:person, race: race)
      FactoryGirl.create(:booking, :inactive, person: inactive)
    end

    visit '/'

    expected_percentage = number_to_percentage(
      100.0 / Person::RACES.count,
      precision: 1,
    )
    within('.demographics-race') do
      Person::RACES.each do |race|
        expect(page).
          to have_css('tr', text: "#{race} 1 #{expected_percentage}")
      end
    end
  end
end
