class Admin::StudentsController < Admin::BaseController

	def update
		errors = []
		begin
			student_datum = {
				id: params[:student][:student_id],
				first_name: params[:student][:student_first_name],
				middle_name: params[:student][:student_middle_name],
				last_name: params[:student][:student_last_name]
			}
			parent_details_datum = {
				first_name: params[:student][:parent_first_name],
				middle_name: params[:student][:parent_middle_name],
				last_name: params[:student][:parent_last_name]
			}
			parent_datum = {
				first_name: params[:student][:parent_first_name],
				middle_name: params[:student][:parent_middle_name],
				last_name: params[:student][:parent_last_name],
				cell_number: params[:student][:cell_number]
			}
			student = Student.find(params[:student][:student_id])
			student.update_attributes(student_datum)
			parent_detail = student.parent.parent_details.find_by_school_id(student.school_id)
			parent_detail.update_attributes(parent_details_datum)
			parent = student.parent
			parent.update_attributes(parent_datum)	
		rescue Exception => e
			errors << "error occured while updating student"
		end
		render json: {success: errors.blank?, errors: errors}
	end


	def index
	    #@grades = Grade.where(school_id: params[:school_id]).includes(:divisions)
	    division =  Division.find(params[:division_id])
	    students_profiles = StudentProfile.where(division_id: params[:division_id])
	    student_data = []
	    students_profiles.each do |student_profile|
	    	if student_profile.student[:activation_status] == true
		      student_data << {
		      					:student_id => student_profile.student_id,
		      					:student_first_name => student_profile.student.first_name,
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
			student = Student.find_by(id: student_id)
			student.activation_status = false
			student.save
			school_id = student.school_id
			parent = student.parent
			childs= Student.where(parent_id: parent.id).where(activation_status: true)
			if childs.empty?
				parent.activation_status = false
				parent.save
			end

		rescue Exception => e
			errors << "error while deactivating student"
		end
		render json: {success: errors.blank?, errors: errors}
	end
	
end
