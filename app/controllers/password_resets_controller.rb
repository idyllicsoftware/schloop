class PasswordResetsController < ApplicationController
  def create
  	user = User.find_by_email(params[:user][:email])
  	user.send_password_reset if user
  	redirect_to root_url,:notice => "Email sent with password reset instructions."
  end

  def edit
  	@user = User.find_by_reset_password_token!(params[:id])
  end

  def update
  	errors = []
	  @user = User.find_by_reset_password_token!(params[:id])
	  if @user.reset_password_sent_at < 2.hours.ago
	    redirect_to new_password_reset_path, :alert => "Password reset has expired."
	  else
	    @user.password = params[:school_admin][:password]
	    @user.save!
	    errors << "Invalid old password" unless @user.valid_password?(params[:school_admin][:password])
	    if errors.blank?
	    	redirect_to root_url, :notice => "Password has been reset!"
	  	else
	    	redirect_to new_password_reset_path, :alert => "Password  is not valid"
	  	end
	  end
  end
end
