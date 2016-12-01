class PagesController < ApplicationController
  def home
    @people = Person.all
    @bookings = Booking.all
    @active_bookings = @bookings.active
    @charges = Charge.all
  end
end
