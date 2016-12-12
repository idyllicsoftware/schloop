class Admin::Teachers::SessionsController < Devise::SessionsController
 
  def after_sign_in_path_for(teacher)
    "/admin/teachers/dashboards/#{teacher.id}"
  end
end