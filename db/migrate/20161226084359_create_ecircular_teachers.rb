class CreateEcircularTeachers < ActiveRecord::Migration
  def change
    create_table :ecircular_teachers do |t|
      t.references :ecircular
      t.references :teacher
      t.references :school
      t.timestamps null: false
    end
  end
end
