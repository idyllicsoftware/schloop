# == Schema Information
#
# Table name: topics
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  master_grade_id   :integer
#  master_subject_id :integer
#  teacher_id        :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_topics_on_master_grade_id_and_master_subject_id  (master_grade_id,master_subject_id)
#  index_topics_on_teacher_id                             (teacher_id)
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
