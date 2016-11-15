class AddTeacherToGradeTeacher < ActiveRecord::Migration
  def change
    add_reference :grade_teachers, :teacher, index: true, foreign_key: true
  end
end
