require 'rails_helper'

describe PagesController do
	describe 'home' do
    it 'should push active booking count into gon' do
      FactoryGirl.create(:booking)

      get :home

      actual_active_bookings = controller.gon.get_variable('population_capacity_chart')[:active_bookings]
      expect(actual_active_bookings).to eq(1)
    end

    it 'should push markers into gon' do
      get :home

      expected_markers = {
        capacity: ENV.fetch('CAPACITY').to_i,
        soft_cap: ENV.fetch('CAPACITY_SOFT_CAP').to_i,
        red_zone_start: ENV.fetch('CAPACITY_RED_ZONE_START').to_i,
        hard_cap: ENV.fetch('CAPACITY_HARD_CAP').to_i
      }

      actual_markers = controller.gon.get_variable('population_capacity_chart')[:markers]
      expect(actual_markers).to eq(expected_markers)
    end
  end
end
