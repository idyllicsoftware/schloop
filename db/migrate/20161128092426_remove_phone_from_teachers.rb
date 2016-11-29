class RemovePhoneFromTeachers < ActiveRecord::Migration
  def change
  	remove_column :teachers, :phone
  end
end
