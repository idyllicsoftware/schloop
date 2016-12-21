class Admin::Teachers::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(teacher)
      "/admin/teachers/dashboards"
  end
  
  def create
   if teacher_signed_in?
     redirect_to after_sign_in_path_for(current_teacher) 
    else
      render json: { errors: "Invalid email or password"} and return  
    end
  end
end
