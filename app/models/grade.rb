# == Schema Information
#
# Table name: grades
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  school_id  :integer
#
# Indexes
#
#  index_grades_on_school_id  (school_id)
#
# Foreign Keys
#
#  fk_rails_9803afc4f6  (school_id => schools.id)
#

class Grade < ActiveRecord::Base
	belongs_to :school
	has_many :division
	has_many :subject
end