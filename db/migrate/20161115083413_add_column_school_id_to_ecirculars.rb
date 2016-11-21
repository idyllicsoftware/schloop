class AddColumnSchoolIdToEcirculars < ActiveRecord::Migration
  def change
  	add_column :ecirculars, :school_id, :integer, null: :false
  end
end
