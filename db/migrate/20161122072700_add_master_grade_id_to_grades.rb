class AddMasterGradeIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :master_grade_id, :integer, default: 0, null: false
  end
end
