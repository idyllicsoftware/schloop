class ChangeColumnActivityFromStringToText < ActiveRecord::Migration
  def up
    change_column :activities, :details, :text
    change_column :activities, :pre_requisite, :text
  end
  def down
    change_column :activities, :details, :string
    change_column :activities, :pre_requisite, :string
  end
end
