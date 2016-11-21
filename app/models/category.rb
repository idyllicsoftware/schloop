# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  name_map      :string           not null
#  category_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_name_map  (name_map)
#

class Category < ActiveRecord::Base

  belongs_to :content
  has_many :content_categories

  enum category_type: { content: 0 }

end
