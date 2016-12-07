# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string
#  grade_id   :integer
#  subject_id :integer
#  teacher_id :integer
#  is_master  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_grade_id    (grade_id)
#  index_topics_on_subject_id  (subject_id)
#  index_topics_on_teacher_id  (teacher_id)
#
# Foreign Keys
#
#  fk_rails_86d011803f  (teacher_id => teachers.id)
#  fk_rails_c53a77d0d5  (grade_id => grades.id)
#  fk_rails_e0edb19e0e  (subject_id => subjects.id)
#

class Topic < ActiveRecord::Base
  belongs_to :grade
  belongs_to :subject
  belongs_to :teacher
end
