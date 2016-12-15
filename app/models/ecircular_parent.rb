# == Schema Information
#
# Table name: ecircular_parents
#
#  id           :integer          not null, primary key
#  ecircular_id :integer
#  student_id   :integer
#  parent_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_ecircular_parents_on_ecircular_id_and_student_id  (ecircular_id,student_id) UNIQUE
#

class EcircularParent < ActiveRecord::Base
  belongs_to :ecircular
  belongs_to :student
  belongs_to :parent

end
