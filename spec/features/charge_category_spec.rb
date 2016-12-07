require "rails_helper"

describe "charge category data" do
  it "is limited to active bookings" do
    login_as FactoryGirl.create(:user)

    active = FactoryGirl.create(:booking)
    inactive = FactoryGirl.create(:booking, :inactive)

    FactoryGirl.create(:charge, booking: active, category: "misdemeanor")
    FactoryGirl.create(:charge, booking: inactive, category: "felony")

    visit "/"

    within(".charge-categories") do
      expect(page).to have_css("tr", text: "misdemeanor 1")
      expect(page).not_to have_css("tr", text: "felony 1")
    end
  end
end
