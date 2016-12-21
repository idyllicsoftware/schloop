class Admin::DivisionsController < ApplicationController
	 
	def create
		errors = []
		if Division.where(name: params[:div_name]).where(grade_id: params[:grade_id]).count > 0
			errors << "division already exist"
		else
			begin
				division = Division.create(name: params[:div_name], grade_id: params[:grade_id])

				if division.errors.present?
					raise "error occured while adding new division"
				end
			rescue Exception => e
				errors << division.errors.full_messages.join(',')
			end
		end
		render json: {success: !errors.present?, errors: errors, division_name: params[:div_name]}
    end 

   
	def destroy
		division = Division.find_by(id: params[:id])
		render json: {success: false, errors: ['grade not found']} and return if division.blank?
		division.destroy!
		render json: {success: true}
	end
end