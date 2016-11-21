# == Schema Information
#
# Table name: activities
#
#  id            :integer          not null, primary key
#  teaches       :string
#  topic         :string           not null
#  title         :string           not null
#  attachment_id :integer
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

  enum grade: { 'Playgroup': 0,
                'Nursery': 1,
                'Jr. KG': 2,
                'Sr. KG': 3,
                '(1-12th Grade)': 4 }

  enum subject: { algebra: 0,
                  civics: 1,
                  drawing: 2,
                  english: 3,
                  geography: 4,
                  geometry: 5,
                  hindi: 6,
                  history: 7,
                  marathi: 8,
                  maths: 9,
                  science: 10 }

  def self.create_activity(create_params)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories)
        activity = Activity.create!(create_params)
        create_activity_categories(activity.id, categories_params)
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
        activity = update_attributes!(update_params)
        activity_categories.destroy_all
        create_activity_categories(activity.id, categories_params)
      rescue => ex
        errors << ex.message
        Rails.logger.debug("Exception in updating activity: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  private

  def create_activity_categories(activity_id, categories_params)
    categories_params.each do |category_id|
      ActivityCategory.create!(activity_id: activity_id, category_id: category_id, category_type: Category.category_types['activity'])
    end
  end
end
