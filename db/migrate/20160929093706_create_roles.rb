class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :role_map
      t.boolean :status

      t.timestamps null: false
    end
  end
end
