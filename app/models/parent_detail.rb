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
	after_create :update_details

	def update_details
		self.update_attributes(:first_name => self.parent.first_name, :last_name => self.parent.last_name, :middle_name => self.parent.middle_name)
	end

	def name
		"#{self.first_name} #{self.middle_name} #{self.last_name}"
	end
end
