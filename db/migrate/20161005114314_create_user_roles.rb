class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true     
      t.timestamps null: false
    end
    add_index :user_roles, :user_id, :name => 'index_user_roles_on_user_id'
      add_index :user_roles, [:user_id, :role_id], unique: :true, :name => 'index_user_roles_on_user_id_and_role_id' 
  end
end
