# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  attachable_type   :string
#  attachable_id     :integer
#  name              :string
#  original_filename :string
#  file_size         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Attachment < ActiveRecord::Base
	belongs_to :attachable, polymorphic: true
	validates :attachable_type, :attachable_id, :name, :original_filename, :presence => true
	validates :name, uniqueness: true

	def self.upload_file(file_to_upload, file_params, metadata, options = {})
		bucket = AWS_CONFIG['bucket']
		response = Util::AwsUtils.upload_to_s3(file_to_upload, bucket, file_params[:url], options) 
		name = "https://#{bucket}.s3.amazonaws.com/#{file_params[:url]}"
		if response[:status] != 'error'
			create_attachment_params = {
				name: name,
				file_size: file_params[:file_size],
				original_filename: file_params[:original_filename]
			}
			attachment = Attachment.create(create_attachment_params)
		end
		return attachment
	end
end
