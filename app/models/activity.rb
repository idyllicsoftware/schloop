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

  has_many :activity_shares, dependent: :destroy

  enum file_sub_type: { reference: 0, thumbnail: 1 }
  enum status: { active: 0, inactive: 1 }

  scope :active, -> { where(status: Activity.statuses['active']) }

  def self.grade_activities(search_params, mapping_data, page, category_ids, user=nil)
    if page.present?
      page = page.to_s.to_i
      page_size = 20
      offset = (page * page_size)
    end
    activities_data = []
    activities = Activity.active.where(search_params)
    activities = activities.includes(:attachments, :categories) if activities.present?
    if category_ids.present?
      activities= activities.joins("LEFT JOIN activity_categories ON activity_categories.activity_id = activities.id
                           LEFT JOIN categories ON activity_categories.category_id = categories.id")
                    .where("categories.id in (?)", category_ids).distinct
    end
    activities = activities.order(id: :desc)
    total_records = activities.count
    activities = activities.offset(offset).limit(page_size) if page.present?
    activities = activities.includes(:activity_shares).sort_by { |activity| activity.activity_shares.first.created_at }.reverse
    # activities_data << activity.data_for_activity(mapping_data)
    activities.each do |activity|
      activities_data << activity.data_for_activity(mapping_data, user)
    end
    return activities_data, total_records
  end

  def data_for_activity(mapping_data, user=nil)
    activity_categories = self.categories
    master_subject = self.master_subject
    subject = mapping_data[:subjects_by_master_id][master_subject.id] rescue nil
    grade = mapping_data[:master_grade_id_grade_id][self.master_grade.id] rescue nil

    thumbnail_data = {}
    self.get_thumbnail_file.select(:original_filename, :name).each do |file|
      thumbnail_data[:s3_url] = file.name
      thumbnail_data[:original_filename] = file.original_filename
    end
    reference_files = []
    self.get_reference_files.select(:original_filename, :name).each do |file|
      reference_files << { s3_url: file.name, original_filename: file.original_filename }
    end

    return {
      grade_id: (grade.id rescue nil),
      grade_name: (grade.name rescue nil),
      master_grade_id: self.master_grade.id,
      master_grade_name: self.master_grade.name,
      subject_id: (subject.id rescue nil) ,
      subject_name: (subject.name rescue nil),
      master_subject_id: master_subject.id,
      master_subject_name: master_subject.name,
      activity: {
          id: id,
          topic: topic,
          teaches: teaches,
          title: title,
          details: details,
          pre_requisite: pre_requisite,
          thumbnail: thumbnail_data,
          references: reference_files,
          categories: activity_categories.select(:id, :name),
          is_followedup: (self.activity_shares.where(teacher: user).present? rescue false)
      }
    }
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

  def share(user, recipients)
    errors = []
    school = user.school
    errors << "No associated school found, please try again." if school.blank?
    return {success: false, errors: errors, data: nil} if errors.present?

    errors << "No recipients found" if recipients.blank?
    return {success: false, errors: errors, data: nil} if errors.present?

    errors << "Invalid teacher" unless user.is_a?(Teacher)
    return {success: false, errors: errors, data: nil} if errors.present?

    share_params = []
    recipients.each do |grade_id, divisions|
      divisions.each do |division_id|
        share_params << {
          activity_id: self.id,
          school_id: school.id,
          teacher_id: user.id,
          grade_id: grade_id,
          division_id: division_id
        }
      end
    end

    begin
      ActivityShare.create(share_params)
    rescue Exception => ex
      errors << ex.message
    end
    return {success: errors.blank?, errors: errors, data: {}}
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
