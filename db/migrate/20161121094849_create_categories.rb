class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :name_map, null: false, index: true
      t.integer :category_type

      t.timestamps null: false
    end
  end
end
