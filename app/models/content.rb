# == Schema Information
#
# Table name: contents
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
#  index_contents_on_grade    (grade)
#  index_contents_on_subject  (subject)
#

class Content < ActiveRecord::Base
  has_many :categories
  has_many :content_categories

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

  def self.create_content(create_params)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories)
        content = Content.create!(create_params)
        create_content_categories(content.id, categories_params)
      rescue => ex
        errors << ex.message
        Rails.logger.debug("Exception in creating content: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  def update_content
    errors = []
    ActiveRecord::Base.transaction do
      begin
        categories_params = create_params.delete(:categories)
        update_attributes!(create_params)
        content.content_categories.destroy_all
        create_content_categories(content.id, categories_params)
      rescue => ex
        errors << ex.message
        Rails.logger.debug("Exception in updating content: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
      end
    end
    { errors: errors, data: [] }
  end

  private

  def create_content_categories(content_id, categories_params)
    categories_params.each do |category_id|
      ContentCategory.create!(content_id: content_id, category_id: category_id, category_type: Category.category_types['content'])
    end
  end
end
