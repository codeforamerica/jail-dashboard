require 'rails_helper'
require 'cancan/matchers'

describe 'User Management' do
  context 'User is an admin' do
    before(:each) do
      @admin = FactoryGirl.build(:user, :admin)
      @ability = Ability.new(@admin)
    end
    it 'should allow an admin to invite a new user' do
      expect(@ability).to be_able_to(:invite, User.new)
    end
    it 'should allow an admin to view a list of all users' do
      expect(@ability).to be_able_to(:index, User)
    end

    it 'should allow an admin to update attributes on a user account' do
      expect(@ability).to be_able_to(:update, User.new)
    end
    it 'should allow an admin to delete a user account' do
      expect(@ability).to be_able_to(:destroy, User.new)
    end
  end
  context 'User is not an admin' do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @ability = Ability.new(@user)
    end
    it 'should not allow a regular user to view a list of all users' do
      expect(@ability).not_to be_able_to(:index, User)
    end
    it 'should not allow a regular user to invite a new user' do
      expect(@ability).not_to be_able_to(:invite, User.new)
    end
    it 'should not allow a regular user to delete a user account' do
      expect(@ability).not_to be_able_to(:destroy, User.new)
    end
    it 'should allow a regular user to update attributes on their own account' do
      expect(@ability).to be_able_to(:update, @user)
    end
    it 'should not allow a regular user to update attributes on another user account' do
      expect(@ability).to be_able_to(:update, User.new)
    end
  end
end
