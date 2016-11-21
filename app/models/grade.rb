# == Schema Information
#
# Table name: grades
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#  master_grade_id :integer          default(0), not null
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
	belongs_to :master_grade
	has_many :divisions
	has_many :subjects
	has_many :ecircular_recipients

	validates :name, :presence => true
end
