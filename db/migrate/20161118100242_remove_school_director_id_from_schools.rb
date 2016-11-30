class RemoveSchoolDirectorIdFromSchools < ActiveRecord::Migration
  def change
    remove_column :schools, :school_director_id, :integer
  end
end
