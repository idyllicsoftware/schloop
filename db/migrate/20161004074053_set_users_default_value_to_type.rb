class SetUsersDefaultValueToType < ActiveRecord::Migration
   def change
  	change_column :users, :type, :string, :default => "SchoolAdmin"
  end
end
