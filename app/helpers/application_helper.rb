module ApplicationHelper  
  def authorize_permission
	  user = current_user
	 	role_ids = UserRole.select("role_id").where(:user_id => user.id).map { |role_record| role_record.role_id }
	 	permission_ids = RolePermission.select(:permission_id).where(role_id: role_ids).map { |permission_record| permission_record.permission_id }

  	is_valid_access = Permission.select(:name).where(id: permission_ids).where(:controller => params[:controller]).where(:action => params[:action])

	  if is_valid_access.empty?
	 		redirect_to root_path
	 	end
  end
end
