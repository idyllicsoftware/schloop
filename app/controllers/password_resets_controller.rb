class PasswordResetsController < ApplicationController
  
  def create
    email = forget_password_params[:email]
    is_user = forget_password_params[:is_user]
    if is_user.eql?('true')
      user = User.find_by(email: email)
    else
      user = Teacher.find_by(email: email)
    end  
    user.send_password_reset if user
    render json: {success:!user.nil?}
  end

  def edit
  	@user = User.find_by_reset_password_token!(edit_params[:format]) rescue nil
    if @user.nil?
      @user = Teacher.find_by_reset_password_token!(edit_params[:format])
    end
  end

  def update
  	errors = []
	  @user = User.find_by_reset_password_token!(update_params[:format]) rescue nil
    if @user.nil?
      @user = Teacher.find_by_reset_password_token!(update_params[:format])
    end
    if params[:user][:password] == params[:user][:password_confirmation]
  	  if @user.reset_password_sent_at < 2.hours.ago
  	    redirect_to new_password_reset_path, :alert => "Password reset has expired."
  	  else
        begin
    	    @user.password = update_params[:user][:password]
    	    @user.save!
        rescue Exception => ex 
          errors << ex.message
  	    end 
        errors << "Invalid old password" unless @user.valid_password?(update_params[:user][:password])

        if errors.blank?
  	    	redirect_to root_url, :notice => "Password has been reset!"
  	  	else
          flash[:invalid_password] = "passowrd is not valid"
  	    	render :edit
  	  	end
  	  end
    else
      flash[:password_mismatch] = "Password does not match. Try again"
      render :edit
    end
  end

  #for parent
  def parent_new
  end
  def create_for_parent
    parent = Parent.find_by_email(params[:email])
    parent.send_password_reset if parent
    redirect_to root_url,:notice => "Email sent with password reset instructions."    
  end
  
  def parent_edit
      @parent = Parent.find_by_reset_password_token!(params[:format])
  end
  
  def parent_update
    errors = []
    @parent = Parent.find_by_reset_password_token!(params[:format])
    if params[:parent][:password] == params[:parent][:password_confirmation]
      if @parent.reset_password_sent_at < 2.hours.ago
        redirect_to new_password_reset_path, :alert => "Password reset has expired."
      else
        begin
          @parent.password = params[:parent][:password]
          @parent.save!
        rescue Exception => e
          errors << ex.message
        end
        errors << "Invalid old password" unless @parent.valid_password?(params[:parent][:password])
        
        if errors.blank?
          redirect_to root_url, :notice => "Password has been reset!"
        else
          redirect_to new_password_reset_path, :alert => "Password  is not valid"
        end
      end
    else
      flash[:password_mismatch] = "Password does not match. Try again"
      render :edit
    end
  end

  private

  def forget_password_params
    params.permit(:email, :is_user)
  end

  def edit_params
    params.permit(:form)
  end

  def update_params
    params.permit({:user=> [:password,:password_confirmation]},:format)
  end
end
