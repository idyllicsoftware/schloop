class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.references :master_grade, index: true, foreign_key: true
      t.references :master_subject, index: true, foreign_key: true
      t.integer :teacher_id, index: true, default: 0
      t.boolean :is_created_by_teacher

      t.timestamps null: false
    end
  end
end
