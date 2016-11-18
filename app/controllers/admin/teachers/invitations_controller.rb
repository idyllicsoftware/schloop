class Admin::Teachers::InvitationsController < Devise::InvitationsController
	
	# def edit
	# 	teacher = Teacher.find_by_invitation_token(params[:invitation_token], true)
	# 	Teacher.accept_invitation!(:invitation_token => params[:invitation_token])
	# 	binding.pry
	# 	sign_in teacher 
	# 	redirect_to edit_teacher_password_path
	# end
end
