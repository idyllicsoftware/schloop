# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  attachable_type   :string
#  attachable_id     :integer
#  name              :string
#  sub_type          :integer
#  original_filename :string
#  file_size         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Attachment < ActiveRecord::Base
	belongs_to :attachable, polymorphic: true
	def self.upload_file(file_to_upload, file_params, metadata, options = {})
		bucket = AWS_CONFIG['bucket']
		response = Util::AwsUtils.upload_to_s3(file_to_upload, bucket, file_params[:url], options) 
		if response[:status] != 'error'
			create_attachment_params = {
				name: file_params[:url],
				file_size: file_params[:file_size],
				original_filename: file_params[:original_filename]
			}
			attachment = Attachment.create(create_attachment_params)
		end
		return attachment
	end
end
