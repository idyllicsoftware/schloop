namespace :db do
  desc 'create database tump'
  task db_dump: [:environment] do
    dump_command = nil
    with_config do |db, user|
      time = Time.now.strftime('%d_%B_%Y_%l:%M_%p')
      @file_name = "schloop_db_backup_#{time}.sql".sub(' ', '')
      @backup_file_path = "#{Rails.root}/db/#{@file_name}"
      dump_command = "pg_dump --verbose --clean --no-owner --no-acl --host=localhost --port=5432 --username=#{user} --dbname=#{db} > #{@backup_file_path}"
    end
    puts dump_command
    system(dump_command)
  end

  desc 'upload database dump to s3'
  task upload_db_dump: [:db_dump] do
    puts 'uploading file to s3'
    bucket = AWS_CONFIG['bucket']
    s3_url = "public/upload/db/#{@file_name}"
    response = Util::AwsUtils.direct_upload(@backup_file_path, bucket, s3_url)
    puts response
  end

  private

  def with_config
    yield ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
