class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :bookmark, index: true, foreign_key: true
      t.string :collaboration_message

      t.timestamps null: false
    end
  end
end
