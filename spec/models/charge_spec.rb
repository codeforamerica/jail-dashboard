require 'rails_helper'

describe Charge do
  it "has a valid factory" do
    FactoryGirl.create(:charge).should be_valid
  end

  describe 'scope' do
    it 'returns bondable charges with bond amount greater than 0' do
      FactoryGirl.create(:charge, bond_amount: nil)
      FactoryGirl.create(:charge, bond_amount: 0)
      FactoryGirl.create(:charge, bond_amount: 100)

      expect(Charge.bondable.count).to eq(1)
    end
  end
end
