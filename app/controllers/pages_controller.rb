class PagesController < ApplicationController
  def home
    @people = Person.all
    @bookings = Booking.all
    @charges = Charge.all
  end
end
