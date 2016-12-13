require 'rails_helper'

describe 'sign out' do
  it 'should allow a signed-in user to sign out' do
    visit '/'
    user = FactoryGirl.create(:user)
    sign_in(user.email, user.password)
    expect(page).to have_content('Signed in successfully.')
    click_link 'Log Out'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
