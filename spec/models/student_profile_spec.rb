# == Schema Information
#
# Table name: student_profiles
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  grade_id    :integer
#  division_id :integer
#  status      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe StudentProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
