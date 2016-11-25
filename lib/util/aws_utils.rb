require 'fileutils'
class Util::AwsUtils

  def self.get_aws_object
    s3 = Aws::S3::Client.new(
      :access_key_id => AWS_CONFIG['aws_access_key_id'],
      :secret_access_key => AWS_CONFIG['aws_secret_accerss_key'],
      :region => AWS_CONFIG['region']
    )
    return s3
  end

  # a general utility methods to upload file to s3
  # this method do not uses temporary storage
  # Date:: 24/03/2015
  def self.direct_upload(path, bucket, s3_location, options = {})
    begin
      # upload file to s3
      acl_flag = options[:acl] || 'authenticated-read'
      content_type = get_content_type(options[:original_filename])
      s3 = get_aws_object
      File.open(path, 'rb') do |file|
        resp = s3.put_object(
          :bucket => bucket,
          :key => s3_location,
          :body => file,
          :acl => acl_flag,
          :content_type => content_type
        )
      end
    rescue Aws::S3::Errors::ServiceError => exc
      return {status: 'error', msg: exc.message}
    rescue Exception => exc
      return {status: 'error', msg: 'Something went wrong. Please contact support.', data: '', filepath: ''}
    end
    {status: 'success', msg: ''}
  end

  # a method to get content based on file name
  # content type is necessary to mange file properly, such as download actions
  def self.get_content_type(original_filename)
    content_types = {
      'csv' => 'text/csv',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls' => 'application/vnd.ms-excel',
      'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt' => 'application/vnd.ms-powerpoint',
      'pptx' => 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    }
    file_extension = original_filename.split('.')[1].downcase rescue ''
    content_types[file_extension]
  end

  def self.get_s3_url(s3_file_name, bucket=AWS_CONFIG['bucket'])
    url = "https://#{bucket}.s3.amazonaws.com/#{s3_file_name}"
    return URI.encode(url)
  end


  def self.upload_to_s3(input_file, bucket , s3_location, options = {})
    bucket ||= AWS_CONFIG['bucket']
    path =  input_file.tempfile.path
    resp = direct_upload(path, bucket, s3_location, options)
    return resp
  end


  def self.copy_file(from_location, to_location)
    error = ''
    begin
      bucket_name = AWS_CONFIG['bucket']
      s3 = get_aws_object
      s3.copy_object(bucket:bucket_name, key:to_location, copy_source:"#{bucket_name}/#{from_location}", acl:'public-read')
    rescue  Exception => e
      Airbrake.notify(e)
      Rails.logger.debug("EXCEPTION in Copy File: Message: #{e.message}\n\n Backtrace: #{e.backtrace}")
      error << e.message
    end
    if error.blank?
      return {status: 'success', msg: ''}
    else
      return {status: 'error', msg: error}
    end
  end

end
