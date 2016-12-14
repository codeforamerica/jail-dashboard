require 'rails_helper'
require 'rake'

describe 'charges rake tasks' do
  describe 'charges:generate' do
    include_context 'rake'

    before(:each) do
      FactoryGirl.create_list(:person, 10, :with_booking)
    end

    let(:task_name) do
      'charges:generate'
    end

    it 'creates 10 charges by default' do
      expect { run_task }.to change { Charge.count }.by(10)
    end

    it 'accepts number of charges to create as argument' do
      expect { run_task('3') }.to change { Charge.count }.by(3)
    end

    it 'assigns charges to existing bookings' do
      run_task('3')

      existing_booking_ids = Booking.pluck(:jms_booking_id)
      actual_booking_ids = Charge.last(3).map(&:booking_id).uniq

      expect(existing_booking_ids).to include(*actual_booking_ids)
    end
  end
end
