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
      crossfilter_data: crossfilter_data(@bookings),
      filters: filters,
    )
  end

  def healthcheck
  end

  private

  def crossfilter_data(bookings)
    bookings.
      joins(:person).
      joins('LEFT JOIN charges ON charges.booking_id = bookings.jms_booking_id').
      joins(:person).
      select(
        :jms_person_id,
        :first_name,
        :last_name,
        :status,
        :facility_name,
        :gender,
        :race,
        :booking_date_time,
        :release_date_time,
        :category,
        :description,
      )
  end

  def filters
    {
      status: values_to_filters(Booking.pluck(:status)),
      location: values_to_filters(Booking.pluck(:facility_name)),
      gender: values_to_filters(Person.pluck(:gender)),
      race: values_to_filters(Person.pluck(:race)),
      category: values_to_filters(Charge.pluck(:category)),
      description: values_to_filters(Charge.pluck(:description)),
    }
  end

  def values_to_filters(db_values)
    db_values.uniq.map { |value| [value, false] }.to_h
  end
end
