class PopulateMasterSubjects < ActiveRecord::Migration
  def up
    Rake::Task['populate_master_subjects'].invoke
  end

  def down
  end
end
