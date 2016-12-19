class PagesController < ApplicationController

  before_action :authenticate_user!, except: :healthcheck

  def home
    @people = Person.all
    @active_people = Person.active

    @bookings = Booking.all
    @active_bookings = @bookings.active
    @weekly_bookings = @bookings.last_week
    @weekly_releases = @bookings.released_last_week

    @active_charges = Charge.joins(:booking).merge(Booking.active)

    @target_bond_people = Person.target_bondable

    gon.push(
      population_capacity_chart: {
        markers: {
          capacity: ENV.fetch("CAPACITY").to_i,
          soft_cap: ENV.fetch("CAPACITY_SOFT_CAP").to_i,
          red_zone_start: ENV.fetch("CAPACITY_RED_ZONE_START").to_i,
          hard_cap: ENV.fetch("CAPACITY_HARD_CAP").to_i
        },
        active_bookings: @bookings.active.count
      },
      crossfilter_data: crossfilter_data(@active_bookings),
      filter_options: {
        status: Booking.pluck(:status).uniq,
        location: Booking.pluck(:facility_name).uniq,
        gender: Person.pluck(:gender).uniq,
        race: Person.pluck(:race).uniq,
      },
    )
  end

  def healthcheck
  end

  private

  def crossfilter_data(active_bookings)
    active_bookings.
      joins(:person).
      select('jms_person_id, first_name, last_name, status, facility_name, gender, race')
  end
end
