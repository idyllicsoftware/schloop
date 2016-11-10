class AddColumnTokenToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :token, :string
    add_index :teachers, :token
  end
end
