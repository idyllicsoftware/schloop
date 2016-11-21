# == Schema Information
#
# Table name: parent_details
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  school_id   :integer
#  first_name  :string
#  last_name   :string
#  middle_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ParentDetail < ActiveRecord::Base
	belongs_to :parent
	belongs_to :school
end
