class Admin::StudentsController < ApplicationController
	before_action :authenticate_user!

	def update
		student = Student.find(params[:student_id])
		student.update_attributes(params[:student])
		parent_detail = student.parent.parent_details.find_by_school_id(s.school_id)
		parent_detail.update_attributes(prams[:parent_detail])
		render json: {success: true}
	end


	def index
	    #@grades = Grade.where(school_id: params[:school_id]).includes(:divisions)
	    division =  Division.find(params[:division_id])
	    students_profiles = StudentProfile.where(division_id: params[:division_id])
	    student_data = []
	    students_profiles.each do |student_profile|
	    	if student_profile.student[:activation_status] == true
		      student_data << {:student_first_name => student_profile.student.first_name,
		      					:student_middle_name => student_profile.student.middle_name,
		      					:student_last_name => student_profile.student.last_name,
		      					:division => division.name.capitalize,
		      					:parent_first_name => student_profile.student.parent.parent_details.last.first_name,
		      					:parent_middle_name => student_profile.student.parent.parent_details.last.middle_name,
		      					:parent_last_name => student_profile.student.parent.parent_details.last.last_name,
		      					:parent_email => student_profile.student.parent.email,
		      					:cell_number => student_profile.student.parent.cell_number
		      				}
		    end
	    end
	    render json: {success: true, student_data: student_data}
	end

	def deactivate
		errors = []
		begin
			student_id = params[:student_id]
			student = Student.where(id: student_id)
			student.activation_status = false
			student.save
		rescue Exception => e
			errors << "error while deactivating student"
		end
		render json: {success: errors.blank?, errors: errors}
	end
end
