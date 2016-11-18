# == Schema Information
#
# Table name: divisions
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  grade_id   :integer
#
# Indexes
#
#  index_divisions_on_grade_id  (grade_id)
#
# Foreign Keys
#
#  fk_rails_6435f301ac  (grade_id => grades.id)
#

class Division < ActiveRecord::Base
	validates :name, :presence => true

	belongs_to :grade
	has_many :ecircular_recipients
end

