class PagesController < ApplicationController
  def home
    @people = Person.all
    @bookings = Booking.all
    @charges = Charge.all
    @bonds = Bond.all
  end
end
