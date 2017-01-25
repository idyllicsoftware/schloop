namespace :seed do
  desc "create roles"
  task :populate_roles => :environment do
    puts "creating roles..."
    require Rails.root.join("db", "role_permissions_data","roles_data.rb").to_s
    roles_data_hash = ROLES
    roles_data_hash.each do |type, role_hash|
      role_hash.each do |role|
        name = role[:name].gsub(/[^0-9a-z]/i, ' ')
        name = name.split.map(&:capitalize).join('')
        Role.where(role_map: role[:name], name: name, status: true).first_or_create
      end
    end
    puts "Roles created"
  end

  desc "create permissions"
  task populate_roles_and_permissions: [:populate_roles] do
    puts "creating permissions..."
    PERMISSIONS = YAML.load_file(Rails.root.join('db/role_permissions_data/permissions.yml'))[:PERMISSIONS]
    PERMISSIONS.each do |controller_data|
      controller_data.each_slice(2) do |controller_name,actions_data|
        controller = controller_name.strip
        actions_data.each do |action_data|
          begin
            action = action_data[:action]
            permissions_name = controller + '-' + action
            puts permissions_name
            flags = JSON.unparse(action_data[:flags] || {})
            role_maps = action_data[:role_maps]
            permission = Permission.where(name: permissions_name, controller: controller,action: action, flags: flags).first_or_create
            Role.where(role_map: role_maps).each do |role|
              RolePermission.where(role: role, permission_id: permission.id).first_or_create
            end
          rescue Exception => e
            puts e.message
            puts e.backtrace
            puts "Exception with permission:: controller: #{controller}\t, action: #{action}, flags: #{flags}\n\n"
            next
          end
        end
      end
    end
    puts "Permissions created"
  end
end