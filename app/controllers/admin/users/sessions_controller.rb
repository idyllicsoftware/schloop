class Admin::Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  
  def after_sign_in_path_for(user)
    if user.type == "ProductAdmin"
      '/admin/schools'
    elsif user.type == "SchoolAdmin"
      school_id = user.school.id rescue ''
      "/admin/schools/school"
    else
      root_path
    end
  end

  def new
    redirect_to '/' and return;
  end  

  # GET /resource/sign_in
  # def new
  #   super 
  # end

  # POST /resource/sign_in
  def create
    if user_signed_in?
      render json: { redirect_url: after_sign_in_path_for(@current_user) }
    else
      render json: { errors: "Invalid email or password"} and return  
    end
  end

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
