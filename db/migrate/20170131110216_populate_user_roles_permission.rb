class PopulateUserRolesPermission < ActiveRecord::Migration
  def up
    Rake::Task['seed:populate_roles_and_permissions'].invoke
    Rake::Task['populate_onetime_user_roles'].invoke
  end
  def down
  end
end
