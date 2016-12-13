require 'rails_helper'

describe 'population capacity' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows current population count', js: true do
    FactoryGirl.create(:booking)

    visit '/'

    in_bed_count = page.find('.pop-capacity-stats .bed-count').text

    expect(in_bed_count).to eq('1 people in beds')
  end

  it 'shows amount over threshold if over a threshold', js: true do
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).with("CAPACITY").and_return(1)

    FactoryGirl.create_list(:booking, 2)

    visit '/'

    over_threshold_count = page.find('.pop-capacity-stats .over-threshold-count').text
    expect(over_threshold_count).to eq("1 over capacity")
  end

  it 'does not show amount over threshold if not over a threshold' do
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).with("CAPACITY").and_return(1)

    visit '/'

    expect(page).not_to have_css('.pop-capacity-stats .over-threshold-count')
  end
end
