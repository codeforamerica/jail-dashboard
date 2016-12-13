require 'rails_helper'

describe Person do
  it 'has a valid factory' do
    FactoryGirl.create(:person).should be_valid
  end

  describe 'scopes' do
    describe 'active' do
      it 'returns people with active bookings' do
        inactive_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, :inactive, person: inactive_person)

        active_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, person: active_person)

        expect(Person.active.count).to eq(1)
        expect(Person.active.first).to eq(active_person)
      end

      it 'only returns person with multiple bookings once' do
        active_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, person: active_person)
        FactoryGirl.create(:booking, person: active_person)

        expect(Person.active.count).to eq(1)
        expect(Person.active.first).to eq(active_person)
      end
    end

    describe 'bondable' do
      it 'returns people with bondable bookings' do
        unbondable_person = FactoryGirl.create(:person)
        unbondable_booking = FactoryGirl.create(:booking, person: unbondable_person)
        FactoryGirl.create(:charge, :unbondable, booking: unbondable_booking)

        bondable_person = FactoryGirl.create(:person)
        bondable_booking = FactoryGirl.create(:booking, person: bondable_person)
        FactoryGirl.create(:charge, booking: bondable_booking)

        expect(Person.bondable.count).to eq(1)
        expect(Person.bondable.first).to eq(bondable_person)
      end
    end
  end

  describe 'active_booking' do
    it 'returns active booking if present' do
      person = FactoryGirl.create(:person)
      active_booking = FactoryGirl.create(:booking, person: person)

      expect(person.active_booking).to eq(active_booking)
    end

    it 'returns nil if not present' do
      person = FactoryGirl.create(:person)
      FactoryGirl.create(:booking, :inactive, person: person)

      expect(person.active_booking).to be_nil
    end
  end
end
