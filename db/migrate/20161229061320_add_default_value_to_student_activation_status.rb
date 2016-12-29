class AddDefaultValueToStudentActivationStatus < ActiveRecord::Migration
  def change
    change_column :students, :activation_status, :boolean, :default => true
    Student.update_all(activation_status: true)
  end
end
