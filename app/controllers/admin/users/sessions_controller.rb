class Admin::Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  def after_sign_in_path_for(user)
    if user.type == "ProductAdmin"
      '/admin/schools'
    else
      '/admin/schools'
    end
  end

  # GET /resource/sign_in
  # def new
  #   super 
  # end

  # POST /resource/sign_in
  # def create
  #   super  
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
