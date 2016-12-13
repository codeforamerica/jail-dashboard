class PersonFactory
  def self.create_person_with_charge(first_name = 'Foo',
                                     last_name = 'Bar',
                                     bond_amount: 100.0,
                                     released: false)

    person = FactoryGirl.create(:person,
                                first_name: first_name,
                                last_name: last_name)
    booking = if released
                FactoryGirl.create(:booking, :inactive, person: person)
              else
                FactoryGirl.create(:booking, person: person)
              end

    FactoryGirl.create(:charge,
                       booking: booking,
                       bond_amount: bond_amount)
    person
  end
end
