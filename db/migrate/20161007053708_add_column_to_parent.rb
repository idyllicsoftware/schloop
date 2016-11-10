class AddColumnToParent < ActiveRecord::Migration
  def change
    add_column :parents, :first_name, :text, null: false, limit: 30
    add_column :parents, :last_name, :text, null: false, limit: 30
    add_column :parents, :guardian_type, :text, null: false
  end
end
