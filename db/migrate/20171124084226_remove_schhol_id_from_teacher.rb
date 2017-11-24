class RemoveSchholIdFromTeacher < ActiveRecord::Migration
  def change
    Teacher.all.each do |teacher|
      school = School.find_by_id(teacher.school_id)
      school.teachers << teacher
    end
    remove_column :teachers, :school_id
  end
end
