class AddGradesAndSubjectsToTeacher < ActiveRecord::Migration
  def change
  	 add_column :teachers, :phone, :string
  end
end
