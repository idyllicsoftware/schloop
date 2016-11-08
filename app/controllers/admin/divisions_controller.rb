class Admin::DivisionsController < ApplicationController
	def create
		errors = []
		begin
			division= Division.create(name: params[:div_name], grade_id: params[:grade_id])
			if division.errors.present?
				raise "error occured while adding new division"
			end
		rescue Exception => e
			errors << division.errors.full_messages.join(',')
		end
		render json: {success: !errors.present?, errors: errors, division_name: params[:div_name]}
    end
    def find_divisions
    end
end
