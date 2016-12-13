require 'rails_helper'

describe 'bonds data' do
  before(:each) do
    login_as FactoryGirl.create(:user)
  end

  def person_with_charge(first_name, last_name, bond_amount, released: false)
    person = FactoryGirl.create(:person, first_name: first_name, last_name: last_name)

    if released
      booking = FactoryGirl.create(:booking, :inactive, person: person)
    else
      booking = FactoryGirl.create(:booking, person: person)
    end

    FactoryGirl.create(:charge,
       booking: booking,
       bond_amount: bond_amount
    )
    person
  end

  it 'shows list of people with unposted bonds greater than $0 and less than $500, sorted by amount' do
    # Non-target charges
    person_with_charge('Shelby', 'Husky', 10.0, released: true)
    person_with_charge('Yuki', 'Mal', 0.0)
    person_with_charge('Sophie', 'Grey', 600.0)

    # Target charges
    target_person_one = person_with_charge('Annie', 'Dog', 100.0)
    FactoryGirl.create(:charge,
      booking: target_person_one.active_booking,
      bond_amount: 75.0
    )
    person_with_charge('Effort', 'Pup', 50.0)

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
