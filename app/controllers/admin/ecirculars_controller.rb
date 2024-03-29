class Admin::EcircularsController < Admin::BaseController
	before_action :find_school, only: [:all, :create]

	def create
		attachments = params[:attachments]
		if(params[:circular_tag].present? && params[:grades].present? && params[:title].present?)
			new_circular = Ecircular.create(circular_params)
			if new_circular.save
				recipients_division_ids = add_recipients_data(params[:grades], params[:school_id], new_circular.id)
				send_notification_to_recipients(recipients_division_ids,new_circular)
				
				render json: { success: true,  circular_id: new_circular.id} and return
			else
				errors = new_circular.errors.full_messages
				render json: { success: false,  errors: errors} and return
			end
		else
			render json: {errors: "title, recipients and tag should be added properly"}
		end
 	end

 	def all
	  circular_ids = @school.ecirculars.ids
		filter_hash = {id: circular_ids}
		circular_data, total_records = Ecircular.school_circulars(@school, current_user, filter_hash)
		render json: {success: true, circulars: circular_data, total_records: total_records}
 	end

 	def upload_file
 		ecircular_id = params[:id]
 		ecircular = Ecircular.find(ecircular_id)
 		file = params[:file]
    file_upload_service = FileUploadService.new
    response = file_upload_service.upload_file_to_s3(file, ecircular, sub_type: 0)
    render json: {
      errors: response[:errors],
      data: response[:data]
    }
 	end
 	
	private
	def find_school
		@school = School.find_by(id: params[:school_id])
		render json: { success: false, errors: ['School not found'] } and return if @school.blank?
	end

	def add_recipients_data(grades, school_id, ecircular_id)
		circular_recipient = []
		grades.each do |grade_id, datum|
			divisions = datum[:divisions]
			grade_id = grade_id.to_i
			if divisions.present?
				divisions.each do |division|
					division_id = division.to_i
					new_record = EcircularRecipient.create(school_id: school_id, grade_id: grade_id, division_id: division_id, ecircular_id: ecircular_id )
					circular_recipient << new_record.division_id
				end
			end
		end
		return circular_recipient
	end

	def send_notification_to_recipients(division_ids,circular) 
    student_ids = StudentProfile.active.where(division_id: division_ids).pluck(:student_id)
    student_ids = Student.where(id: student_ids).active.ids
    circular.send_notification(student_ids)
  end

	def circular_params
		user_type = current_user.type rescue ''
		if user_type == 'ProductAdmin'
		 	created_by_type = Ecircular.created_by_types[:product_admin]
		elsif user_type == 'SchoolAdmin'
		 	created_by_type = Ecircular.created_by_types[:school_admin]
		else
		 	created_by_type = Ecircular.created_by_types[:teacher]
		end
		return {
		 	title: params[:title],
		 	body: params[:body],
		 	circular_tag: Ecircular.circular_tags[params[:circular_tag]],
		 	created_by_type: created_by_type,
		 	created_by_id: current_user.id,
		 	school_id: @school.id
		}
	end
end
