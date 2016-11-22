class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :teaches
      t.string :topic, null: false
      t.string :title, null: false
      t.integer :master_grade_id, null: false
      t.integer :master_subject_id, null: false
      t.text :details
      t.text :pre_requisite

      t.timestamps null: false
    end
  end
end
