class CreateEcircularParents < ActiveRecord::Migration
  def change
    create_table :ecircular_parents do |t|
      t.references :ecircular
      t.integer :student_id
      t.integer :parent_id
      t.timestamps null: false
    end

    add_index :ecircular_parents, [:ecircular_id, :student_id], unique: true
  end
end
