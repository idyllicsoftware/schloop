class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.references :master_grade, index: true, foreign_key: true
      t.references :master_subject, index: true, foreign_key: true
      t.references :teacher, index: true, foreign_key: true
      t.boolean :is_created_by_teacher

      t.timestamps null: false
    end
  end
end
