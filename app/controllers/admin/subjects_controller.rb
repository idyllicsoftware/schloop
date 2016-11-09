class Admin::SubjectsController < ApplicationController

  def create
  	errors = []
	begin
    	subject = Subject.create(name: params[:subject_name],grade_id: params[:grade_id])

    	if subject.errors.present?
    		raise "error occured while adding new subject"
    	end
    	rescue Exception => e
		  errors << subject.errors.full_messages.join(',')
  end
    render json: {success: e.nil?, errors: errors, subject_name: params[:subject_name]}
    
  end
end
