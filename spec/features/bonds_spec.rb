require 'rails_helper'

describe 'bonds data' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  it 'shows list of people with unposted bonds greater than $0 and less than $500, sorted by amount' do
    target_person_one = PersonFactory.create_person_with_charge('Annie',
                                                                'Dog',
                                                                bond_amount: 100.0)
    FactoryGirl.create(:charge,
                       booking: target_person_one.active_booking,
                       bond_amount: 75.0)

    PersonFactory.create_person_with_charge('Effort', 'Pup', bond_amount: 50.0)

    visit '/'

    within('.bonds') do
      expect(page).to have_text('Current inmates with $500 or smaller bonds')

      rows = all('tr')

      expect(rows.length).to eq(3)
      expect(rows[0]).to have_text('Name Bond')
      expect(rows[1]).to have_text('Pup, Effort $50')
      expect(rows[2]).to have_text('Dog, Annie $175')
    end
  end
end
