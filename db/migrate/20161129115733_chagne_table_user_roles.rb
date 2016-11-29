class ChagneTableUserRoles < ActiveRecord::Migration
  def change
    remove_column :user_roles, :user_original_id
    add_column :user_roles, :entity_type, :string, null: :false
    add_column :user_roles, :entity_id, :integer, null: :false
  end
end
