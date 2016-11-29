class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_original_id 
      t.references :role, foreign_key: true     
      t.timestamps null: false
    end
  end
end
