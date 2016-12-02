class Admin::SchoolAdminsController < ApplicationController
	include ApplicationHelper
	before_action :authenticate_user!
	before_action :find_school, only: [:index, :create]
	before_action :find_school_admin, only: [:update, :destroy]
	before_filter :authorize_permission

	layout "admin"

	def index
		render json: {success: false, errors: ['School not found']} and return if @school.blank?
		school_admins = @school.school_admins.select(:id, :first_name, :last_name, :cell_number, :email).order('created_at').all
		render json: {success: true, school_admins: school_admins}
	end

	def create
		render json: {success: false, errors: ['School not found']} and return if @school.blank?
		response = create_school_admin(@school, create_school_admin_params)
		render :json => response
	end

	def update
		render json: {success: false, errors: ['School admin not found']} and return if @school_admin.blank?
		response = update_school_admin(@school_admin, update_school_admin_params)
		render :json => response
	end

	def destroy
		render json: {success: false, errors: ['School admin not found']} and return if @school_admin.blank?
		@school_admin.destroy!
		render json: {success: true}
	end

	private

	def find_school
		@school = School.find_by(id: params[:school_id])
	end

	def find_school_admin
		@school_admin = SchoolAdmin.find_by(id: params[:id])
	end

	def create_school_admin(school, school_admin_datum)
		errors = []
		ActiveRecord::Base.transaction do
			begin
				school_admin = create_school_admin!(school, school_admin_datum)
				if school_admin.save
					binding.pry
					Admin::AdminMailer.welcome_message(school_admin.email, school_admin.first_name, school_admin.password).deliver_now
				else
					errors += school_admin.errors.full_messages
					raise('custom_errors')
				end
			rescue Exception => ex
				if ex.message != 'custom_errors'
					errors << 'Something went wrong. Please contact dev team.'
					Rails.logger.debug("Exception in creating school: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
				end
				raise ActiveRecord::Rollback
			end
		end
		return {success: errors.blank?, errors: errors}
	end

	def create_school_admin!(school, datum)
		create_params = {
				first_name: datum[:first_name],
				last_name: datum[:last_name],
				email: datum[:email],
				cell_number: datum[:cell_number],
				password: Devise.friendly_token.gsub('-','').first(6)
		}
		return school.school_admins.create(create_params)
	end

	def create_school_admin_params
		params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
	end

	def update_school_admin(school_admin, datum)
		errors = []
		ActiveRecord::Base.transaction do
			begin
				update_params = {
						first_name: datum[:first_name],
						last_name: datum[:last_name],
						cell_number: datum[:cell_number]
				}
				school_admin.update_attributes(update_params)
				unless school_admin.save
					errors += school_admin.errors.full_messages
					raise('custom_errors')
				end
			rescue Exception => ex
				if ex.message != 'custom_errors'
					errors << 'Something went wrong. Please contact dev team.'
					Rails.logger.debug("Exception in creating admins: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
				end
				raise ActiveRecord::Rollback
			end
		end

		return {success: errors.blank?, errors: errors}
	end

	def update_school_admin_params
		params.require(:administrator).permit(:first_name, :last_name, :cell_number)
	end

end
