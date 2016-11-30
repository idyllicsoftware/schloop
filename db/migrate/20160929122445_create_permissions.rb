class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.text :flags

      t.timestamps null: false
    end
  end
end
