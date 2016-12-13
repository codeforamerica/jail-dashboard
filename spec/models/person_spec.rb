require 'rails_helper'

describe Person do
  it 'has a valid factory' do
    FactoryGirl.create(:person).should be_valid
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns people with active bookings' do
        inactive_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, :inactive, person: inactive_person)

        active_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, person: active_person)

        expect(Person.active.count).to eq(1)
        expect(Person.active.first).to eq(active_person)
      end

      it 'only returns one person for multiple active bookings' do
        active_person = FactoryGirl.create(:person)
        FactoryGirl.create(:booking, person: active_person)

        booking = FactoryGirl.build(:booking, person: active_person)
        booking.save(validate: false)

        expect(Person.active.count).to eq(1)
        expect(Person.active.first).to eq(active_person)
      end
    end
  end

  describe '.target_bondable' do
    it 'returns people with active bondable charges totaling less than $500' do
      PersonFactory.create_person_with_charge(bond_amount: 0)
      PersonFactory.create_person_with_charge(bond_amount: 600)
      PersonFactory.create_person_with_charge(released: true)

      target_person = PersonFactory.create_person_with_charge(bond_amount: 300)

      expect(Person.target_bondable.count).to eq(1)
      expect(Person.target_bondable.first).to eq(target_person)
    end

    it 'sorts the returned value in ascending bond total' do
      person_200 = PersonFactory.create_person_with_charge(bond_amount: 200)
      person_100 = PersonFactory.create_person_with_charge(bond_amount: 100)

      expect(Person.target_bondable.count).to eq(2)
      expect(Person.target_bondable.first).to eq(person_100)
      expect(Person.target_bondable.last).to eq(person_200)
    end
  end

  describe 'active_booking' do
    it 'returns active booking if present' do
      person = FactoryGirl.create(:person)
      active_booking = FactoryGirl.create(:booking, person: person)

      expect(person.active_booking).to eq(active_booking)
    end

    it 'returns most recent active booking if multiple present' do
      person = FactoryGirl.create(:person)
      FactoryGirl.create(:booking, :last_week, person: person)

      newer_active_booking = FactoryGirl.build(:booking, person: person, booking_date_time: DateTime.now)
      newer_active_booking.save!(validate: false)
      newer_active_booking.reload

      expect(person.active_booking).to eq(newer_active_booking)
    end

    it 'returns nil if not present' do
      person = FactoryGirl.create(:person)
      FactoryGirl.create(:booking, :inactive, person: person)

      expect(person.active_booking).to be_nil
    end
  end
end
