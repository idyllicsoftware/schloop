module ApplicationHelper
	def authorize_permission
		user = current_user
		role_ids = UserRole.where(entity_type: user.class.name ,entity_id: user.id).pluck(:role_id)
		permission_ids = RolePermission.where(role_id: role_ids).pluck(:permission_id)

		is_valid_access = Permission.select(:name).where(id: permission_ids)
												.where(:controller => params[:controller])
												.where(:action => params[:action])

		redirect_to root_path if is_valid_access.empty?
	end

	def after_sign_in_path_for(user)
		if user.type == "ProductAdmin"
		  '/admin/schools'
		elsif user.type == "SchoolAdmin"
		  school_id = user.school.id rescue ''
		  "/admin/schools/#{school_id}"
		else
		  root_path
		end
	end
end

