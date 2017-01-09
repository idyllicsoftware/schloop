class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commentable_type
      t.integer :commentable_id
      t.integer :commented_by
      t.text :message

      t.timestamps null: false
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
