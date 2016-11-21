# == Schema Information
#
# Table name: content_categories
#
#  id          :integer          not null, primary key
#  content_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ContentCategory < ActiveRecord::Base
  belongs_to :content
  belongs_to :category
end
