# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string
#  name_map      :string           not null
#  category_type :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_name_map  (name_map)
#

class Category < ActiveRecord::Base
  has_many :activity_categories, dependent: :destroy
  has_many :activities, through: :activity_categories

  enum category_type: { activity: 0 }
end
