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
          capacity: ENV.fetch("CAPACITY").to_i,
          soft_cap: ENV.fetch("CAPACITY_SOFT_CAP").to_i,
          red_zone_start: ENV.fetch("CAPACITY_RED_ZONE_START").to_i,
          hard_cap: ENV.fetch("CAPACITY_HARD_CAP").to_i
        },
        active_bookings: @bookings.active.count
      }
    )
  end
end
