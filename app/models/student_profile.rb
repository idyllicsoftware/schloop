# == Schema Information
#
# Table name: student_profiles
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  grade_id    :integer
#  division_id :integer
#  status      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class StudentProfile < ActiveRecord::Base
	belongs_to :student
	belongs_to :division
	belongs_to :grade
	validates :division_id, :presence => { :message => " is invalid" }

	enum status: { active: 0, inactive: 1 }

end
