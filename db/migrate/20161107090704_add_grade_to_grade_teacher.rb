class AddGradeToGradeTeacher < ActiveRecord::Migration
  def change
    add_reference :grade_teachers, :grade, index: true, foreign_key: true
  end
end
