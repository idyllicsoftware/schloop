class AddTimestampsToEcirculars < ActiveRecord::Migration
  def change
  	change_table :ecirculars do |t|
  		t.timestamps 
  	end
  end
end
