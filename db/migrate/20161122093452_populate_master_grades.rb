class PopulateMasterGrades < ActiveRecord::Migration
  def up
    Rake::Task['populate_msater_grades'].invoke
  end

  def down
  end
end
