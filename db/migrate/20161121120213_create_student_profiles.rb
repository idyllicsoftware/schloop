class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.references :student
      t.references :grade
      t.references :division
      t.string :status
      t.timestamps null: false	
    end
  end
end
