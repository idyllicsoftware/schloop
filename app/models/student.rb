# == Schema Information
#
# Table name: students
#
#  id          :integer          not null, primary key
#  school_id   :integer
#  first_name  :string
#  last_name   :string
#  middle_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Student < ActiveRecord::Base
	belongd_to :school
	has_many :student_profiles
end
