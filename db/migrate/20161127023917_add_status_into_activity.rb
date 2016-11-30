class AddStatusIntoActivity < ActiveRecord::Migration
  def change
    add_column :activities, :status, :integer, default: 0, null: false
  end
end
