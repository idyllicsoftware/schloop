class PasswordResetsController < ApplicationController
  # for user (PA or SA)
  def create
  	user = User.find_by_email(params[:user][:email])
  	user.send_password_reset if user
  	redirect_to root_url,:notice => "Email sent with password reset instructions."
  end

  def edit
  	@user = User.find_by_reset_password_token!(params[:format])
  end

  def update
  	errors = []
	  @user = User.find_by_reset_password_token!(params[:format])
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

  # for teacher
  def create_for_teacher
    teacher = Teacher.find_by_email(params[:email])
    teacher.send_password_reset if teacher
    redirect_to root_url,:notice => "Email sent with password reset instructions."
  end

  def teacher_edit
    @teacher = Teacher.find_by_reset_password_token!(params[:format])
  end

  def teacher_update
    errors = []
    @teacher = Teacher.find_by_reset_password_token!(params[:format])
    if @teacher.reset_password_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    else
      @teacher.password = params[:teacher][:password]
      @teacher.save!
      errors << "Invalid old password" unless @teacher.valid_password?(params[:teacher][:password])
      if errors.blank?
        redirect_to root_url, :notice => "Password has been reset!"
      else
        redirect_to new_password_reset_path, :alert => "Password  is not valid"
      end
    end
  end

  #for parent
  def parent_new
  end
  def create_for_create
    
  end
  
  def parent_edit
    
  end
  
  def parent_update
    
  end
end
