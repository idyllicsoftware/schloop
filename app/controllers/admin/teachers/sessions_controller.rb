class Admin::Teachers::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(teacher)
    '/admin/topics'
  end
end
