class Admin::Users::DashboardsController < ApplicationController
	before_action :authenticate_user!
	def index
	end

	def school_admin_dashboard
	end

	def admin_dashboard
	end
end
