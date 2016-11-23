class CreateEcircularRecipients < ActiveRecord::Migration
  def change
    create_table :ecircular_recipients do |t|
      t.integer :school_id
      t.integer :grade_id
      t.integer :division_id

      t.timestamps null: false
    end
  end
end
