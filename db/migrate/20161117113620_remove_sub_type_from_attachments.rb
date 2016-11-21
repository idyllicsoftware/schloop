class RemoveSubTypeFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :sub_type, :integer
  end
end
