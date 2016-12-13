class Admin::Teachers::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(teacher)
    redirect_to "/admin/teachers/dashboards/#{teacher.id}"
  end
  
end