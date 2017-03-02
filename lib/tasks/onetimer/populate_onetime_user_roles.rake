#Rake task to populate roles for existing user
desc "populate roles for existing user"
task :populate_onetime_user_roles => :environment do
  puts "creating user roles..."
  users = []
  ActiveRecord::Base.transaction do
    begin  
      school_admins = SchoolAdmin.all.to_a || []
      product_admin = ProductAdmin.first.to_a || []
      teachers = Teacher.all.to_a || []
      parents = Parent.all.to_a || []
      users = school_admins + product_admin + teachers + parents
      users.each do |user|
        role = Role.find_by(name: user.class.name)
        UserRole.where(role_id: role.id, entity_type: user.class.name, entity_id: user.id).first_or_create
      end
      puts "done"
    rescue Exception => e
      puts e.message
      puts e.backtrace
      raise ActiveRecord::Rollback
    end
  end
end
