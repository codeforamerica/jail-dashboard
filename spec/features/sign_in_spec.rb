require 'rails_helper'

describe 'sign in' do
  it 'should allow a user with valid credentials to sign in' do
    visit '/'
    user = FactoryGirl.create(:user)
    sign_in(user.email, user.password)
    expect(page).to have_content('Signed in successfully.')
  end

  it 'should prevent a user from signing in without a registered email' do
    visit '/'
    user = FactoryGirl.create(:user)
    sign_in('user@example.com', user.password)
    expect(page).to have_content('Invalid Email or password.')
  end

  it 'should prevent a user from signing in without a valid password' do
    visit '/'
    user = FactoryGirl.create(:user)
    sign_in(user.email, 'abcde')
    expect(page).to have_content('Invalid Email or password.')
  end

  it 'should allow a service to access the healthcheck without logging in' do
    visit '/healthcheck'
    expect(page).to have_content('Success')
  end
end
