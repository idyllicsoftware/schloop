class Admin::EcircularsController < ApplicationController
	
	def index
		@circulars = Ecircular.order('id desc').limit(10)
	end

	def new
		@school_id = params[:school_id]
		@grades = Grade.where(school_id: @school_id).includes(:divisions)
		@circulars = Ecircular.where(school_id: @school_id).order('id desc')
	end

	def create
		attachments = params[:attachments]
		new_circular = Ecircular.create(circular_params)
		if attachments.present?
			count = 0
			attachments.each  do |file|
				count = count + 1
				extension =  File.extname(file.original_filename)
				file_name = File.basename(file.original_filename, ".*")
				file_name = "#{file_name}_#{Time.now.to_i}#{extension}"
				ecircular_file_upload_service = Admin::EcircularFileUploadService.new
				response = ecircular_file_upload_service.upload_ecircular_file_to_s3(file, file_name, new_circular)
			end
		end
		sending_response = send_circular(params[:grades], params[:school_id], new_circular.id)		
		redirect_to admin_school_ecirculars_path	
 	end
 
 	def show
	  @circular=Ecircular.order('id desc').limit(10)
 	end

	private

	def send_circular(recipients, school_id, ecircular_id)
		recipients.each do |grade|
			grade_id = grade[0][0].to_i
			grade_data = grade[1]
			divisions = grade_data[:division]
			if divisions.present?
				divisions.each do |division|
					division_id = division.to_i
					circular_recipient = EcircularRecipient.create(:school_id => school_id, :grade_id => grade_id, :division_id => division_id,:ecircular_id => ecircular_id )
				end
			end
		end
	end

	def circular_params
 		user_type = @current_user.type rescue ''
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
		 	circular_type: Ecircular.circular_tags[params[:circular_type].to_sym],
		 	created_by_type:created_by_type, 
		 	created_by_id: current_user.id,
		 	school_id: current_user.school_id
		}
	end
end
