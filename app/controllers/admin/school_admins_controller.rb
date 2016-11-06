class Admin::SchoolAdminsController < ApplicationController
	before_action :authenticate_user!
	before_action :find_school, only: [:index, :create, :update, :destroy]
	layout "admin"

	def index
		render json: {success: false, errors: ['School not found']} and return if @school.blank?
		school_admins = @school.school_admins.select(:id, :first_name, :last_name, :cell_number, :email).order('created_at').all
		render json: {success: true, school_admins: school_admins}
	end

	def create
	end

	def update

	end

	def destroy

	end

	private

	def find_school
		@school = School.find_by(id: params[:school_id])
	end

	def create_school_admin!(school, datum)
		create_params = {
				first_name: datum[:first_name],
				last_name: datum[:last_name],
				email: datum[:email],
				cell_number: datum[:cell_number],
				password: '12345678'
		}
		return school.school_admins.create(create_params)
	end

	def school_admin_params
		params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
	end
	 

end
