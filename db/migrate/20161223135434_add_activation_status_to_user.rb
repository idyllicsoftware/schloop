class AddActivationStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :activation_status, :boolean
  end
end
