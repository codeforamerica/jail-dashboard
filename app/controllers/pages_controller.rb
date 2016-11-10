class PagesController < ApplicationController
  def home
    @bookings = Booking.all
    @charges = Charge.all
  end
end
