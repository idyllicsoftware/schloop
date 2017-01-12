# == Schema Information
#
# Table name: activity_shares
#
#  id          :integer          not null, primary key
#  activity_id :integer          not null
#  school_id   :integer          not null
#  teacher_id  :integer          not null
#  grade_id    :integer          not null
#  division_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_activity_shares_on_activity_id                (activity_id)
#  index_activity_shares_on_grade_id_and_division_id   (grade_id,division_id)
#  index_activity_shares_on_school_id                  (school_id)
#  index_activity_shares_on_school_id_and_activity_id  (school_id,activity_id)
#

require 'rails_helper'

RSpec.describe ActivityShare, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
