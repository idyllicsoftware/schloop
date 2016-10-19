class Admin::Users::DashboardsController < ApplicationController
	include ApplicationHelper
	before_action :authenticate_user!
	before_filter :authorize_permission
	def index
	end

	def school_admin_dashboard
	end

	def admin_dashboard
	end
end
