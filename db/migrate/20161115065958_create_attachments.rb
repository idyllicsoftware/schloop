class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachable_type
      t.integer :attachable_id
      t.string :name
      t.integer :sub_type
      t.string :original_filename
      t.integer :file_size

      t.timestamps null: false
    end
  end
end
