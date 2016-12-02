require 'rails_helper'

describe 'population capacity' do
	before(:each) do
		FactoryGirl.create(:booking)
	end

	def have_svg_text(text)
		have_css('svg text', text: text)
	end

	it 'shows current population count', js: true do
		visit '/'

		expect(page).to have_svg_text('1')
	end

	it "runs es6", :js do
		visit "/"

		expect(page.evaluate_script('`hello, ${"world"}`')).to eq("hello, world")
	end
end
