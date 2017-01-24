class Admin::Teachers::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(teacher)
    "/admin/teachers/dashboards"
  end
  
  def create
  	if teacher_signed_in?
  		render json: { redirect_url: after_sign_in_path_for(current_teacher) }
    else
      render json: { errors: "Invalid email or password"} and return  
    end
  end
end
