class RenameColumnEcircularTypeToEcircularTags < ActiveRecord::Migration
  def change
    rename_column :ecirculars, :circular_type, :circular_tag
  end
end
