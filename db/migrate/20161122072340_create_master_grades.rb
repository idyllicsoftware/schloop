class CreateMasterGrades < ActiveRecord::Migration
  def change
    create_table :master_grades do |t|
      t.string :name
      t.string :name_map, null: false, index: true

      t.timestamps null: false
    end
  end
end
