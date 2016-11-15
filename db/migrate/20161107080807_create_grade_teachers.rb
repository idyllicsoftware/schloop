class CreateGradeTeachers < ActiveRecord::Migration
  def change
    create_table :grade_teachers do |t|

      t.timestamps null: false
    end
  end
end
