class AddColumnCodeToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :code, :string, null: false
  end
end
