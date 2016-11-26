class CreateParentDetails < ActiveRecord::Migration
  def change
    create_table :parent_details do |t|
      t.references :parent	
      t.references :school	
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.timestamps null: false
    end
  end
end
