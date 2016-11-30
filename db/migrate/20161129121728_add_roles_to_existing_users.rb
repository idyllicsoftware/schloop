class AddRolesToExistingUsers < ActiveRecord::Migration
  def change
    Rake::Task['seed:populate_roles'].invoke
    Rake::Task['seed:populate_roles_and_permissions'].invoke

    ProductAdmin.all.each do |product_admin|
      role = Role.find_by(name: "ProductAdmin")
      UserRole.create(entity_type: product_admin.class.name, entity_id: product_admin.id, role_id: role.id) if role.present?
    end

    SchoolAdmin.all.each do |school_admin|
      role = Role.find_by(name: "SchoolAdmin")
      UserRole.create(entity_type: school_admin.class.name, entity_id: school_admin.id, role_id: role.id) if role.present?
    end

    Teacher.all.each do |teacher|
      role = Role.find_by(name: "Teacher")
      UserRole.create(entity_type: teacher.class.name, entity_id: teacher.id, role_id: role.id) if role.present?
    end
  end
end
