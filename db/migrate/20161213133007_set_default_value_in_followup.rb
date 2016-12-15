class SetDefaultValueInFollowup < ActiveRecord::Migration
  def change
    change_column :followups, :followup_message, :string, default: ""
    change_column :followups, :bookmark_id, :integer , :null => false, :unique => true
    change_column :followups, :followup_message, :string, :null => false

  end
end
