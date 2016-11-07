class AddSubjectToGradeTeacher < ActiveRecord::Migration
  def change
    add_reference :grade_teachers, :subject, index: true, foreign_key: true
  end
end
