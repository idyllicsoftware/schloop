class AddColumnPrincipalToSchools < ActiveRecord::Migration
  def change
    remove_column :users, :principal_name, :string
    add_column :schools, :principal_name, :string
  end
end
