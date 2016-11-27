# == Schema Information
#
# Table name: subjects
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  subject_code      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  grade_id          :integer
#  teacher_id        :integer
#  division_id       :integer
#  master_subject_id :integer          default(0), not null
#
# Indexes
#
#  index_subjects_on_division_id  (division_id)
#  index_subjects_on_grade_id     (grade_id)
#  index_subjects_on_teacher_id   (teacher_id)
#
# Foreign Keys
#
#  fk_rails_0f2d832c5a  (division_id => divisions.id)
#  fk_rails_33d539df11  (grade_id => grades.id)
#  fk_rails_cac7f2be05  (teacher_id => teachers.id)
#

class Subject < ActiveRecord::Base
  belongs_to :grade
  belongs_to :master_subject
end
