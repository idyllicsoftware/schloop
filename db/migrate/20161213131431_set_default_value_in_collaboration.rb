class SetDefaultValueInCollaboration < ActiveRecord::Migration
  def change
    change_column :collaborations, :collaboration_message, :string, default: ""
    change_column :collaborations, :bookmark_id, :integer , :null => false, :unique => true
    change_column :collaborations, :collaboration_message, :string, :null => false
  end
end
