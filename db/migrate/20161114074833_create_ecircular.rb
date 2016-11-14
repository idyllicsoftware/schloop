class CreateEcircular < ActiveRecord::Migration
  def change
    create_table :ecirculars do |t|
    	t.string :title
    	t.text :body
    	t.integer :circular_type
    	t.integer	:created_by_type
    	t.integer :created_by_id
    end
  end
end
