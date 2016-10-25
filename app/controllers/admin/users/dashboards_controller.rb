class Admin::Users::DashboardsController < ApplicationController
	before_action :authenticate_user!

	layout "admin"
	
	def index
	end

	def school_admin_dashboard
	end

	def admin_dashboard
		@schools = School.all
	end

end
