# == Schema Information
#
# Table name: ecircular_teachers
#
#  id           :integer          not null, primary key
#  ecircular_id :integer
#  teacher_id   :integer
#  school_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EcircularTeacher < ActiveRecord::Base
  belongs_to :ecircular
  belongs_to :teacher
  belongs_to :school
end
