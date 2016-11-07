class Admin::DivisionsController < ApplicationController
	def create
		division= Division.create(name: params[:div_name], grade_id: params[:grade_id])
		school = Grade.where(id: params[:grade_id]).pluck(:school_id)
		redirect_to "/admin/schools/#{school[0]}"
    end
    def find_divisions
    end
end
