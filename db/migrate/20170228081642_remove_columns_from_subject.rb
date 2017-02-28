class RemoveColumnsFromSubject < ActiveRecord::Migration
  def self.up
    remove_column :subjects, :subject_code
    remove_column :subjects, :teacher_id
    remove_column :subjects, :division_id
  end

  def self.down
    add_column :subjects, :subject_code, :string
    add_column :subjects, :teacher_id, :integer
    add_column :subjects, :division_id, :integer
  end
end
