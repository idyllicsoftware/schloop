class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :name_map, null: false, index: true
      t.integer :category_type, default: 0

      t.timestamps null: false
    end
  end
end
