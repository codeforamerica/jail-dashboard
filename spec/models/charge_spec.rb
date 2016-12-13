require 'rails_helper'

describe Charge do
  it 'has a valid factory' do
    FactoryGirl.create(:charge).should be_valid
  end

  describe 'scope' do
    describe '.bondable' do
      it 'returns charges with bond amount greater than 0' do
        FactoryGirl.create(:charge, bond_amount: nil)
        FactoryGirl.create(:charge, bond_amount: 0)
        charge = FactoryGirl.create(:charge, bond_amount: 100)

        expect(Charge.bondable.count).to eq(1)
        expect(Charge.bondable.first).to eq(charge)
      end
    end
  end
end
