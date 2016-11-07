class AddDivisionToGradeTeacher < ActiveRecord::Migration
  def change
    add_reference :grade_teachers, :division, index: true, foreign_key: true
  end
end
