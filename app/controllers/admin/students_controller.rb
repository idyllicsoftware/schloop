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
	    @grades = Grade.where(school_id: params[:school_id]).includes(:divisions)
	    @division =  Division.includes("student_profiles").find(params[:division_id])
	    student_data = []
	    @division.student_profiles.each do |student_profile|
	      student_data << {:student_first_name => student_profile.student.first_name,
	      					:student_middle_name => student_profile.student.middle_name,
	      					:student_last_name => student_profile.student.last_name,
	      					:division => @division.name.capitalize,
	      					:parent_first_name => student_profile.student.parent.parent_details.last.first_name,
	      					:parent_middle_name => student_profile.student.parent.parent_details.last.middle_name,
	      					:parent_last_name => student_profile.student.parent.parent_details.last.last_name,
	      					:parent_email => student_profile.student.parent.email,
	      					:cell_number => student_profile.student.parent.cell_number
	      				}
	    end
	    render json: {success: true, student_data: student_data}
	  end

end
