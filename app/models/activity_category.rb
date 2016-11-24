# == Schema Information
#
# Table name: activity_categories
#
#  id          :integer          not null, primary key
#  activity_id :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ActivityCategory < ActiveRecord::Base
  belongs_to :activity
  belongs_to :category
end
