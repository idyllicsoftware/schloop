class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.text :data
      t.integer :data_type
      t.text :caption
      t.references :teacher, index: true, foreign_key: true
      t.references :topic, index: true, foreign_key: true
      t.string :preview_image_url
      t.integer :views
      t.integer :likes
      t.references :grade, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true
      t.references :school, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
