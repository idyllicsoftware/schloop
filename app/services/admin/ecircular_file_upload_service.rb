class Admin::EcircularFileUploadService < BaseService
	def upload_ecircular_file_to_s3(input_file, file_name, circular)
		file_params = {
			original_filename: file_name,
			file_size: input_file.size,
			url: "public/upload/#{Time.now.to_i}_#{file_name}",
		}
	  ecircular_file_attachment = Attachment.upload_file(input_file, file_params, {}, {acl: 'public-read', original_filename: file_params[:original_filename]}) 
		ecircular_file_attachment.attachable = circular
		ecircular_file_attachment.save
	end
end