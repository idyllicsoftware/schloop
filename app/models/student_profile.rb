# == Schema Information
#
# Table name: student_profiles
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  grade_id    :integer
#  division_id :integer
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class StudentProfile < ActiveRecord::Base
	belongs_to :student
	belongs_to :division
	belongs_to :grade
	validates :division_id, :presence => { :message => " is invalid" }

end
