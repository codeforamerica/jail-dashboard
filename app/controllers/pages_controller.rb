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
      crossfilter_tables: {
        crossfilter_data: @active_bookings.joins(:person).select('jms_person_id, first_name, last_name, status').to_json
      }
    )
  end

  def bookings
    respond_to do |format|
      format.csv do
        render text: Booking.to_csv
      end
    end
  end

  def crossfilter
  end

  def healthcheck
  end
end
