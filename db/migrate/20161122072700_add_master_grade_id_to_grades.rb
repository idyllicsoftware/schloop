class AddMasterGradeIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :master_grade_id, :integer, null: false
  end
end
