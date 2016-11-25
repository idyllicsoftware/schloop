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
#

class Activity < ActiveRecord::Base
  belongs_to :master_grade
  belongs_to :master_subject
  has_many :activity_categories, dependent: :destroy
  has_many :categories, through: :activity_categories
  has_many :attachments, as: :attachable, dependent: :destroy

  enum file_sub_type: { reference: 0, thumbnail: 1 }

  def self.grade_activities(search_params, page_size, offset)
    activities_data = []
    activities = Activity.where(search_params).order(id: :desc)
    total_records = activities.count
    activities = activities.offset(offset).limit(page_size) if search_params[:subject_id].present?

    activities.each do |activity|
      master_subject = activity.master_subject
      activities_data << {
        grade_id: master_grade.id,
        grade_name: master_grade.name,
        subject_id: master_subject.id,
        subject_name: master_subject.name,
        activity: {
          id: activity.id,
          topic: activity.topic,
          teaches: activity.teaches,
          title: activity.title,
          details: activity.details,
          pre_requisite: activity.pre_requisite
        }
      }
    end
    return activities_data, total_records
  end

  def self.create_activity(create_params)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories)
        reference_files = create_params.delete(:reference_files)
        thumbnail_file = create_params.delete(:thumbnail_file)

        activity = Activity.create!(create_params)
        create_activity_categories(activity.id, categories_params)
        # upload_files(activity, reference_files, thumbnail_file)
      rescue => ex
        errors << 'Failed to create activity. Please enter details properly.'
        Rails.logger.debug("Exception in creating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  # def update_activity(update_params)
  #   errors = []
  #   ActiveRecord::Base.transaction do
  #     begin
  #       categories_params = update_params.delete(:categories)
  #       reference_files = create_params.delete(:reference_files)
  #       thumbnail_file = create_params.delete(:thumbnail_file)

  #       activity = update_attributes!(update_params)
  #       activity_categories.destroy_all
  #       create_activity_categories(activity.id, categories_params)
  #       upload_files(activity, reference_files, thumbnail_file)
  #     rescue => ex
  #       errors << ex.message
  #       Rails.logger.debug("Exception in updating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
  #     end
  #   end
  #   { errors: errors, data: [] }
  # end

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
