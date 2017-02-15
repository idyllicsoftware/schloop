class SetParentsActivationStatusToDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :activation_status, :boolean, :default => true
    Parent.where(activation_status: nil).update_all(activation_status: true)
  end
end
