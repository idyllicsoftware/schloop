class AddActivationStatusToStudent < ActiveRecord::Migration
  def change
    add_column :students, :activation_status, :boolean
  end
end
