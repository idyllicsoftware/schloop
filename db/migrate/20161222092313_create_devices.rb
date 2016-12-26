class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :deviceable_id
      t.string  :deviceable_type
      t.integer :device_type, default: 0
      t.string  :token, null: false
      t.string  :os_version
      t.integer :status, default: 0
      t.timestamps null: false
    end
    add_index :devices, [:deviceable_type, :deviceable_id]
  end
end
