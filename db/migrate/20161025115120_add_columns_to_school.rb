class AddColumnsToSchool < ActiveRecord::Migration
  def change
    add_column :schools , :board , :string
  end
end
