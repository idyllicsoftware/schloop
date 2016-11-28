class FileUploadService < BaseService
  def upload_file_to_s3(input_file, source, options)
    attachment_id = ''
    errors = []
    begin
      ext = File.extname(input_file.original_filename)
      file_name = File.basename(input_file.original_filename)
      file_name = "#{file_name}_#{Time.now.to_i}#{ext}"
      file_params = {
        original_filename: file_name,
        file_size: input_file.size,
        sub_type: options[:sub_type],
        url: "public/upload/#{Time.now.to_i}_#{file_name}",
      }
      attachment = Attachment.upload_file(input_file, file_params, { }, { acl: 'public-read', original_filename: file_params[:original_filename] })
      attachment.attachable = source
      attachment.save!
      attachment_id = attachment.id
    rescue => ex
      errors << 'error in uploading file to s3.'
      Rails.logger.debug("Exception in creating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
    end
    { errors: errors, data: attachment_id }
  end
end
