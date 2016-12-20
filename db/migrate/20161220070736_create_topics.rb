class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.references :master_grade
      t.references :master_subject
      t.integer :teacher_id, default: 0
        	
      t.timestamps null: false
    end
    add_index :topics, [:master_grade_id, :master_subject_id]
    add_index :topics, :teacher_id
  end

end
