class AddCellNumberToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :cell_number, :string
  end
end
