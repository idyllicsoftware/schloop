class Admin::SubjectsController < ApplicationController

  def create
  	errors = []
	begin
    	subject = Subject.create(name: params[:subject_name],grade_id: params[:grade_id])
	rescue Exception => e
		errors << "can't store subject."
    end
    render json: {success: e.nil?, errors: errors, subject_name: params[:subject_name]}
    
  end
end
