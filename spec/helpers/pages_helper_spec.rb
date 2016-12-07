require 'rails_helper'

describe PagesHelper do
  describe 'present_percent' do
    it 'should calculate percent and format to one decimal point' do
      formatted_percent = helper.present_percent(2, 3)

      expect(formatted_percent).to eq('66.7%')
    end
  end
end
