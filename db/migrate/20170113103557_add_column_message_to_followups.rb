class AddColumnMessageToFollowups < ActiveRecord::Migration
  def change
    add_column :followups, :followup_message, :string
  end
end
