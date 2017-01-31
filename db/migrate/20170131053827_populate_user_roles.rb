class PopulateUserRoles < ActiveRecord::Migration
  def up
    Rake::Task['populate_onetime_user_roles'].invoke
  end
  def down
  end
end
