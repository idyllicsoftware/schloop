class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.references :grade, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true
      t.references :teacher, index: true, foreign_key: true
      t.boolean :is_master

      t.timestamps null: false
    end
  end
end
