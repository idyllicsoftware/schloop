# == Schema Information
#
# Table name: grades
#
#  id         :integer          not null, primary key
#  name       :string           not null
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

require 'rails_helper'

RSpec.describe Grade, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
