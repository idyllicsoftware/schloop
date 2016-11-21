class CreateContentCategories < ActiveRecord::Migration
  def change
    create_table :content_categories do |t|
      t.integer :content_id, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end
  end
end
