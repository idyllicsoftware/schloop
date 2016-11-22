class AddSubTypeToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :sub_type, :integer, default: 0, null: false
  end
end
