require 'rails_helper'
require 'open-uri'
RSpec.describe "productionTest", type: :feature do
	it "visit to production" do
		res = open('http://www.schloop.co/')
		binding.pry
		expect(res.status).to eq ["200","OK"]
	end
end