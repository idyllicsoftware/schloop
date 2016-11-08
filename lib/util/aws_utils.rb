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


  def self.files_exists_in?(dir_name)
    bucket = AWS_CONFIG['bucket']
    bucket.as_tree(prefix: "#{dir_name}").children.each do |obj|
      if obj.branch?
        return true if self.files_exists_in?(obj.prefix)
      else
        next if obj.key.last == '/'
        return true
      end
    end
    false
  end

  def self.delete_files(s3_path, recur_num=1)
    bucket = AWS_CONFIG['bucket']

    puts "#{' '*recur_num*2}--> In folder #{s3_path}"
    bucket.as_tree(prefix: "#{s3_path}").children.each do |obj|
      if obj.branch?
        self.delete_files(obj.prefix, recur_num+1)
      else
        next if obj.key.last == '/'
        puts "#{' '*(recur_num*2+2)}--> Deleting #{obj.key}"
        aws_object = self.get_aws_object
        aws_object.delete_object(bucket_name: APP_CONF[:s3][:bucket], key: obj.key)
      end
    end
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


  def self.download_file(s3_location)
    bucket = AWS_CONFIG['bucket']
    #Create local directory for uploads if not exists
    unless File.directory?(Attachment::TMP_UPLOAD_FOLDER)
      FileUtils.mkdir_p(Attachment::TMP_UPLOAD_FOLDER)
    end
    directory = Attachment::TMP_UPLOAD_FOLDER
    # create the file path
    name = s3_location.split('/').last
    path = File.join(directory, name)
    begin
      # download file from s3
      s3 = get_aws_object
      File.open(path, 'wb') do |file|
        s3.get_object(bucket: bucket, key: s3_location) do |data|
          file.write(data)
        end
      end
    rescue Aws::S3::Errors::ServiceError => exc
      return {status: 'error', msg: exc.message, data: '', filepath: ''}
    rescue Exception => exc
      return {status: 'error', msg: 'Something went wrong. Please contact support.', data: '', filepath: ''}
    end
    return {status: 'success', msg: '', filepath: path}
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

  # a general utility methods to upload file to s3
  # note this method is speciallly designed to upload input from form
  # this method uses temparary storage
  # Date:: 24/03/2015
  #
  # <b>Expects</b>
  # * <b>file_to_upload</b><em>(File Object)</em> File to Upload
  #
  # <b>Returns</b>
  # * status <em>(Boolean)</em> upload status
  def self.upload_using_tmp(input_file, bucket, s3_location, options = {})

    name =  input_file.original_filename
    #Create local directory for uploads if not exists
    unless File.directory?(Attachment::TMP_UPLOAD_FOLDER)
      FileUtils.mkdir_p(Attachment::TMP_UPLOAD_FOLDER)
    end

    directory = Attachment::TMP_UPLOAD_FOLDER
    # create the file path
    path = File.join(directory, name)
    begin
      # write the file to local path
      File.open(path, "wb") { |f| f.write(input_file.read) }
      direct_upload(path, bucket, s3_location, options)
    rescue Exception => e
      Airbrake.notify(e)
      return {status: 'error', msg: e.message}
    end
    File.delete(path) rescue ''
    return {status: 'success', msg: ''}
  end

  def self.upload_to_s3(input_file, bucket , s3_location, options = {})
    bucket ||= AWS_CONFIG['bucket']
    if input_file.instance_of? String
      resp = direct_upload(input_file, bucket, s3_location, options)
      File.delete(input_file)
    else
      resp = upload_using_tmp(input_file, bucket, s3_location, options)
    end
    return resp
  end

  def self.get_s3_url(s3_file_name, bucket=AWS_CONFIG['bucket'])
    url = "https://#{bucket}.s3.amazonaws.com/#{s3_file_name}"
    return URI.encode(url)
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

# current version of aws-se used : Class: Aws::S3::Client version 2 (latest of now)
# http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html

# Possible options for s3 commands
# acl: "private|public-read|public-read-write|authenticated-read|bucket-owner-read|bucket-owner-full-control",
# # required
# bucket: "BucketName",
# cache_control: "CacheControl",
# content_disposition: "ContentDisposition",
# content_encoding: "ContentEncoding",
# content_language: "ContentLanguage",
# content_type: "ContentType",
# # required
# copy_source: "CopySource",
# copy_source_if_match: "CopySourceIfMatch",
# copy_source_if_modified_since: Time.now,
# copy_source_if_none_match: "CopySourceIfNoneMatch",
# copy_source_if_unmodified_since: Time.now,
# expires: Time.now,
# grant_full_control: "GrantFullControl",
# grant_read: "GrantRead",
# grant_read_acp: "GrantReadACP",
# grant_write_acp: "GrantWriteACP",
# # required
# key: "ObjectKey",
# metadata: { "MetadataKey" => "MetadataValue" },
# metadata_directive: "COPY|REPLACE",
# server_side_encryption: "AES256",
# storage_class: "STANDARD|REDUCED_REDUNDANCY",
# website_redirect_location: "WebsiteRedirectLocation",
# sse_customer_algorithm: "SSECustomerAlgorithm",
# sse_customer_key: "SSECustomerKey",
# sse_customer_key_md5: "SSECustomerKeyMD5",
# ssekms_key_id: "SSEKMSKeyId",
# copy_source_sse_customer_algorithm: "CopySourceSSECustomerAlgorithm",
# copy_source_sse_customer_key: "CopySourceSSECustomerKey",
# copy_source_sse_customer_key_md5: "CopySourceSSECustomerKeyMD5",
# request_payer: "requester"
