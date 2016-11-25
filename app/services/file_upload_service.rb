class FileUploadService < BaseService
  def upload_file_to_s3(input_file, source, options)
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
    attachment.save
  end
end
