class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.integer :trackable_id
      t.string  :trackable_type
      t.integer :user_id
      t.string  :user_type
      t.integer :event
      t.timestamps null: false
    end
    add_index :trackers, [:trackable_type, :trackable_id]
    add_index :trackers, [:user_type, :user_id]

    add_index :trackers, [:trackable_type, :trackable_id, :user_type, :user_id, :event], name: 'index_all', unique: true
  end
end
