class AddMasterSubjectIdToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :master_subject_id, :integer
  end
end
