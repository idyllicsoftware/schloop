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

require 'rails_helper'

RSpec.describe EcircularParent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
