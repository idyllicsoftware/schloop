class RemoveColumnsFromSubject < ActiveRecord::Migration
  def self.up
    remove_column :subjects, :subject_code
  end

  def self.down
    add_column :subjects, :subject_code, :string
  end
end
