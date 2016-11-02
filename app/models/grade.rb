# == Schema Information
#
# Table name: grades
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Grade < ActiveRecord::Base
	belongs_to :school
	has_many :division
	has_many :subject
end
