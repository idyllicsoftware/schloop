namespace :seed do
  #Rake task to populate roles
  desc "rake seed:populate_roles RAILS_ENV=<environment_name> --trace #Task for creating roles"
  task populate_roles: :environment do
    puts "Creating Roles..."
    User.reset_column_information

#
 #   default_user = User.first_or_create(:email => "Product-Admin",
  #
   # default_user = User.first_or_create(:email => "admin@schloop.co",
    #                                     :password => "Test123",
     #                                    :type => "ProductAdmin")

    require Rails.root.join('db','role_permission_data','roles_data.rb').to_s
    roles_data_hash = ROLES

    puts "Roles created..."

  end

  desc "rake seed:populate_roles_and_permissions RAILS_ENV=<environment_name> --trace #Task for populating roles and permissions"
  task populate_roles_and_permissions: [:populate_roles] do
    puts "Creating Permissions"
    PERMISSIONS = YAML.load_file(Rails.root.join('db/role_permissions_data/permission.yml'))[:PERMISSIONS]

    PERMISSIONS.each do

    end
  end
end