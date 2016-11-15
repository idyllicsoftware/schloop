# == Schema Information
#
# Table name: grade_teachers
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  division_id :integer
#  subject_id  :integer
#  teacher_id  :integer
#  grade_id    :integer
#
# Indexes
#
#  index_grade_teachers_on_division_id  (division_id)
#  index_grade_teachers_on_grade_id     (grade_id)
#  index_grade_teachers_on_subject_id   (subject_id)
#  index_grade_teachers_on_teacher_id   (teacher_id)
#
# Foreign Keys
#
#  fk_rails_055d6e0c75  (grade_id => grades.id)
#  fk_rails_1f8ae2b6d8  (teacher_id => teachers.id)
#  fk_rails_2d162fa38a  (division_id => divisions.id)
#  fk_rails_dcc3bac41c  (subject_id => subjects.id)
#

class GradeTeacher < ActiveRecord::Base
end
