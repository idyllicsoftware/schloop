# == Schema Information
#
# Table name: activities
#
#  id            :integer          not null, primary key
#  teaches       :string
#  topic         :string           not null
#  title         :string           not null
#  grade         :integer          not null
#  subject       :integer          not null
#  details       :text
#  pre_requisite :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_activities_on_grade    (grade)
#  index_activities_on_subject  (subject)
#

class Activity < ActiveRecord::Base
  has_many :categories
  has_many :activity_categories
  has_many :attachments, as: :attachable

  enum file_sub_type: { reference: 0, thumbnail: 1 }

  enum grade: { 'Playgroup': 0,
                'Nursery': 1,
                'Jr. KG': 2,
                'Sr. KG': 3,
                '(1-12th Grade)': 4 }

  enum subject: { algebra: 0,
                  arts: 1,
                  biology: 2,
                  chemistry: 3,
                  civics: 4,
                  drawing: 5,
                  english: 6,
                  general_knowledge: 7,
                  geography: 8,
                  geometry: 9,
                  hindi: 10,
                  history: 11,
                  marathi: 12,
                  mathematics: 13,
                  physics: 14,
                  science: 15,
                  social_science: 16,
                  computer_science: 17,
                  life_skills: 18 }

  def self.create_activity(create_params)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories)
        reference_files = create_params.delete(:reference_files)
        thumbnail_file = create_params.delete(:thumbnail_file)

        activity = Activity.create!(create_params)
        create_activity_categories(activity.id, categories_params)
        upload_files(activity, reference_files, thumbnail_file)
      rescue => ex
        errors << ex.message
        Rails.logger.debug("Exception in creating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  def update_activity(update_params)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = update_params.delete(:categories)
        reference_files = create_params.delete(:reference_files)
        thumbnail_file = create_params.delete(:thumbnail_file)

        activity = update_attributes!(update_params)
        activity_categories.destroy_all
        create_activity_categories(activity.id, categories_params)
        upload_files(activity, reference_files, thumbnail_file)
      rescue => ex
        errors << ex.message
        Rails.logger.debug("Exception in updating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  private

  def upload_files(activity, reference_files, thumbnail_file)
    reference_files.each do |file|
      FileUploadService.new.upload_file_to_s3(file, activity, sub_type: Activity.file_sub_types['reference'])
    end
    FileUploadService.new.upload_file_to_s3(thumbnail_file, activity, sub_type: Activity.file_sub_types['thumbnail'])
  end

  def create_activity_categories(activity_id, categories_params)
    categories_params.each do |category_id|
      ActivityCategory.create!(activity_id: activity_id, category_id: category_id, category_type: Category.category_types['activity'])
    end
  end
end
