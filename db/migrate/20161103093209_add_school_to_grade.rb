class AddSchoolToGrade < ActiveRecord::Migration
  def change
    add_reference :grades, :school, index: true, foreign_key: true
  end
end
