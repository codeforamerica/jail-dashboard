class PagesController < ApplicationController

  before_action :authenticate_user!, except: :healthcheck

  def home
    @people = Person.all
    @active_people = Person.joins(:bookings).merge(Booking.active)

    @bookings = Booking.all
    @active_bookings = @bookings.active
    @weekly_bookings = @bookings.last_week

    @active_charges = Charge.joins(:booking).merge(Booking.active)

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

  def healthcheck
  end
end
