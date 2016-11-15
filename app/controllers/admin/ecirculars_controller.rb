class Admin::EcircularsController < ApplicationController
	
	def index
		@circular=Ecircular.order('id desc').limit(10)
	end

	def new
	end

	def create
		attachments = params[:attachments]
		new_circular = Ecircular.create(circular_params)
		count = 0
		attachments.each  do |file|
			count = count + 1
			file_name = params[:file_name] + "-#{count}"
			ecircular_file_upload_service = Admin::EcircularFileUploadService.new
			response = ecircular_file_upload_service.upload_ecircular_file_to_s3(file,file_name,new_circular.id)
		end

		redirect_to admin_school_ecirculars_path	
 	end

	private

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
		 	circular_type: Ecircular.circular_types[params[:circular_type].to_sym], 
		 	created_by_type:created_by_type, 
		 	created_by_id: current_user.id
		 }
	end
end
