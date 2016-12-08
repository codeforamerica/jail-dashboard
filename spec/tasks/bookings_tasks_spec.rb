require 'rails_helper'
require 'rake'

describe 'bookings rake tasks' do
  describe 'bookings:generate_weekly' do
    include_context 'rake'

    before(:each) do
      FactoryGirl.create_list(:person, 10)
    end

    let(:task_name) do
      'bookings:generate_weekly'
    end

    it 'creates 10 bookings by default' do
      expect { run_task }.to change { Booking.count }.by(10)
    end

    it 'accepts number of bookings to create as argument' do
      expect { run_task('3') }.to change { Booking.count }.by(3)
    end

    it 'creates bookings within past week' do
      run_task('3')

      booking_dates = Booking.last(3).map(&:booking_date_time)

      expect(booking_dates.first).to be_within(1.week).of(DateTime.now)
      expect(booking_dates.second).to be_within(1.week).of(DateTime.now)
      expect(booking_dates.third).to be_within(1.week).of(DateTime.now)
    end

    it 'assigns existing people to bookings' do
      run_task('3')

      existing_people_ids = Person.pluck(:jms_person_id)
      actual_people_ids = Booking.last(3).map(&:person_id).uniq

      expect(existing_people_ids).to include(*actual_people_ids)
    end

    it 'creates mix of current bookings, and with inactive bookings since booking date' do
      run_task('3')

      bookings = Booking.last(3)

      expect(bookings.first.release_date_time).to be_nil_or(:>=, bookings.first.booking_date_time)
      expect(bookings.second.release_date_time).to be_nil_or(:>=, bookings.second.booking_date_time)
      expect(bookings.third.release_date_time).to be_nil_or(:>=, bookings.third.booking_date_time)
    end

    it 'assigns an existing facility name' do
      run_task('3')

      expected_facility_names = ['Main Jail Complex', 'Medical Facility', 'County Correctional Center']
      actual_facility_names = Booking.last(3).map(&:facility_name).uniq

      expect(expected_facility_names).to include(*actual_facility_names)
    end

    it 'assigns a valid status' do
      run_task('3')

      expected_statuses = [Booking::PRE_TRIAL, Booking::SENTENCED]
      actual_statuses = Booking.last(3).map(&:status).uniq

      expect(expected_statuses).to include(*actual_statuses)
    end
  end
end
