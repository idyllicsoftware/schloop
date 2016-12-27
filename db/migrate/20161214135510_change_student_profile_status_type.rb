class ChangeStudentProfileStatusType < ActiveRecord::Migration
  def change
  	change_column :student_profiles, :status, 'integer USING CAST(status AS integer)', default: 0, null: false
  end
end
