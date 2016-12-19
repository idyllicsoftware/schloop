# == Schema Information
#
# Table name: topics
#
#  id                    :integer          not null, primary key
#  title                 :string           not null
#  master_grade_id       :integer
#  master_subject_id     :integer
#  teacher_id            :integer          default(0)
#  is_created_by_teacher :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_topics_on_master_grade_id    (master_grade_id)
#  index_topics_on_master_subject_id  (master_subject_id)
#  index_topics_on_teacher_id         (teacher_id)
#
# Foreign Keys
#
#  fk_rails_b4a8849da9  (master_grade_id => master_grades.id)
#  fk_rails_daa7ec056b  (master_subject_id => master_subjects.id)
#

class Topic < ActiveRecord::Base
  belongs_to :master_grade
  belongs_to :master_subject
  belongs_to :teacher
end
