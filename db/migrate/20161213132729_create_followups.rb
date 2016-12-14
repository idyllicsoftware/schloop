class CreateFollowups < ActiveRecord::Migration
  def change
    create_table :followups do |t|
      t.references :bookmark, index: true, foreign_key: true
      t.string :followup_message

      t.timestamps null: false
    end
  end
end
