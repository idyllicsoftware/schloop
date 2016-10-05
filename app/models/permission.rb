class Permission < ActiveRecord::Base

	has_many :role_permissions, dependent: :destroy
	has_many :roles, through: :role_permissions
	
end
