class PagesController < ApplicationController

  before_action :authenticate_user!

  def home
    @people = Person.all
    @bookings = Booking.all
    @active_bookings = @bookings.active
    @charges = Charge.all

    gon.push(
      population_capacity_chart: {
        markers: {
          capacity: ENV.fetch("CAPACITY"),
          soft_cap: ENV.fetch("CAPACITY_SOFT_CAP"),
          red_zone_start: ENV.fetch("CAPACITY_RED_ZONE_START"),
          hard_cap: ENV.fetch("CAPACITY_HARD_CAP")
        },
        active_bookings: @bookings.active.count
      }
    )
  end
end
