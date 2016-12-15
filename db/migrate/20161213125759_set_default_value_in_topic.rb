class SetDefaultValueInTopic < ActiveRecord::Migration
  def change
    change_column :topics, :teacher_id, :integer, default: -1
    change_column :topics, :is_created_by_teacher, :boolean, default: false

    change_column :topics, :title, :string, :null => false
    change_column :topics, :master_grade_id, :integer, :null => false
    change_column :topics, :master_subject_id, :integer, :null => false    
    change_column :topics, :is_created_by_teacher, :boolean, :null => false
  end
end
