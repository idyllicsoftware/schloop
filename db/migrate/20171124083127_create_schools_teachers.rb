class CreateSchoolsTeachers < ActiveRecord::Migration
  def change
    create_table :schools_teachers do |t|
      t.integer :school_id
      t.integer :teacher_id
    end
  end
end
