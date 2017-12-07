class AddSchoolIdToTeacher < ActiveRecord::Migration
  def change
  	add_column :teachers, :school_id, :integer
  	add_index :teachers, :email, :unique => true
  end
end
