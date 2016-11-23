# == Schema Information
#
# Table name: master_grades
#
#  id         :integer          not null, primary key
#  name       :string
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_master_grades_on_name_map  (name_map)
#

class MasterGrade < ActiveRecord::Base
  has_many :grades
  has_many :activities #, dependent: :destroy  #TODO GAURAV
end
