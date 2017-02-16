require 'rails_helper'
RSpec.configure do |c|
	c.include ControllerMacros
end
RSpec.describe Admin::Users::SessionsController, type: :controller do
	login_school_admin
	login_product_admin
	login_teacher
	login_parent
	describe "#create" do
	end
end
