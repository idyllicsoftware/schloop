class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.text :data
      t.text :caption
      t.string :url
      t.string :preview_image_url
      t.integer :likes, default: 0, null: false
      t.integer :views, default: 0, null: false
      t.references :topic
      t.integer :data_type, default: 0, null: false
      t.references :school
      t.references :grade
      t.references :subject
      t.references :teacher

      t.timestamps null: false
    end
    add_index :bookmarks, :teacher_id
    add_index :bookmarks, :school_id
    add_index :bookmarks, [:grade_id, :subject_id]
  end
end
