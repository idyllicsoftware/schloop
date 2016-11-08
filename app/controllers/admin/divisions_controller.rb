class Admin::DivisionsController < ApplicationController
	def create
		errors = []
		begin
			division= Division.create(name: params[:div_name], grade_id: params[:grade_id])
		rescue Exception => e
			errors << "can't store division."
		end
		render json: {success: e.nil?, errors: []}
    end
    def find_divisions
    end
end
