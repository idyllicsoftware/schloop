class AddColumnPrincipalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :principal_name, :string
  end
end
