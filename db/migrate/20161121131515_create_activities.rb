class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :teaches
      t.string :topic, null: false
      t.string :title, null: false
      t.integer :attachment_id
      t.integer :grade, null: false, index: true
      t.integer :subject, null: false, index: true
      t.text :details
      t.text :pre_requisite

      t.timestamps null: false
    end
  end
end
