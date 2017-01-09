class CreateSocialTrackers < ActiveRecord::Migration
  def change
    create_table :social_trackers do |t|
      t.integer :sc_trackable_id
      t.string  :sc_trackable_type
      t.integer :user_id
      t.string  :user_type
      t.integer :event

      t.timestamps null: false
    end
    add_index :social_trackers, [:sc_trackable_type, :sc_trackable_id]
    add_index :social_trackers, [:user_type, :user_id]
    add_index :social_trackers, [:sc_trackable_type, :sc_trackable_id, :user_type, :user_id, :event], name: 'index_sc_all', unique: true

  end
end
