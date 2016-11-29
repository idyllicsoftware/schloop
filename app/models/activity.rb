# == Schema Information
#
# Table name: activities
#
#  id                :integer          not null, primary key
#  teaches           :string
#  topic             :string           not null
#  title             :string           not null
#  master_grade_id   :integer          not null
#  master_subject_id :integer          not null
#  details           :text
#  pre_requisite     :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer          default(0), not null
#

class Activity < ActiveRecord::Base
  belongs_to :master_grade
  belongs_to :master_subject
  has_many :activity_categories, dependent: :destroy
  has_many :categories, through: :activity_categories
  has_many :attachments, as: :attachable, dependent: :destroy

  enum file_sub_type: { reference: 0, thumbnail: 1 }
  enum status: { active: 0, inactive: 1 }

  scope :active, -> { where(status: Activity.statuses['active']) }

  def self.grade_activities(search_params, mapping_data, page)
    if page.present?
      page = page.to_s.to_i
      page_size = 20
      offset = (page * page_size)
    end
    activities_data = []
    activities = Activity.where(search_params).includes(:attachments).order(id: :desc)
    total_records = activities.count
    activities = activities.offset(offset).limit(page_size) if page.present?

    activities.each do |activity|
      master_subject = activity.master_subject

      subject = mapping_data[:subjects_by_master_id][master_subject.id] rescue nil
      grade = mapping_data[:master_grade_id_grade_id][activity.master_grade.id]

      thumbnail_data = {}
      activity.get_thumbnail_file.select(:original_filename, :name).each do |file|
        thumbnail_data[:s3_url] = file.name
        thumbnail_data[:original_filename] = file.original_filename
      end
      reference_files = []
      activity.attachments.select(:original_filename, :name).each do |file|
        reference_files << { s3_url: file.name, original_filename: file.original_filename }
      end
      activities_data << {
        grade_id: grade.id,
        grade_name: grade.name,
        master_grade_id: activity.master_grade.id,
        master_grade_name: activity.master_grade.name,
        subject_id: (subject.id rescue nil) ,
        subject_name: (subject.name rescue nil),
        master_subject_id: master_subject.id,
        master_subject_name: master_subject.name,
        activity: {
          id: activity.id,
          topic: activity.topic,
          teaches: activity.teaches,
          title: activity.title,
          details: activity.details,
          pre_requisite: activity.pre_requisite,
          thumbnail: thumbnail_data,
          references: reference_files
        }
      }
    end
    return activities_data, total_records
  end

  def self.create_activity(create_params)
    activity_id = 0
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories) || []
        activity = Activity.create!(create_params)
        activity_id = activity.id
        create_activity_categories(activity.id, categories_params)
      rescue => ex
        errors << 'Failed to create activity. Please enter details properly.'
        Rails.logger.debug("Exception in creating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: activity_id }
  end

  def deactivate_activity
    errors = []
    begin
      inactive!
    rescue => ex
      errors << 'Something went wrong. Please contact to support team.'
      Rails.logger.debug("Exception in deactivating activity: Message: #{ex.message}/n/n/n Backtrace: #{ex.backtrace}")
    end
    { success: errors.blank?, errors: errors }
  end

   def get_thumbnail_file
    attachments.where(sub_type: Activity.file_sub_types['thumbnail'])
  end

  def get_reference_files
    attachments.where(sub_type: Activity.file_sub_types['reference'])
  end

  private

  def upload_files(activity, reference_files, thumbnail_file)
    file_upload_service = FileUploadService.new
    reference_files.each do |file|
      file_upload_service.upload_file_to_s3(file, activity, sub_type: Activity.file_sub_types['reference'])
    end
    file_upload_service.upload_file_to_s3(thumbnail_file, activity, sub_type: Activity.file_sub_types['thumbnail'])
  end

  def self.create_activity_categories(activity_id, categories_params)
    categories_params.each do |category_id|
      ActivityCategory.create!(activity_id: activity_id, category_id: category_id)
    end
  end
end
