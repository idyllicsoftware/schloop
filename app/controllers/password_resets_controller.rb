class PasswordResetsController < ApplicationController
  
  def create
  	user = User.find_by_email(params[:user][:email])
  	user.send_password_reset if user
  	#redirect_to root_url,:notice => "Email sent with password reset instructions."
    render json: {success: !user.nil?}
  end

  def edit
  	@user = User.find_by_reset_password_token!(params[:format])
  end

  def update
  	errors = []
	  @user = User.find_by_reset_password_token!(params[:format])
    if params[:school_admin][:password] == params[:school_admin][:password_confirmation]
  	  if @user.reset_password_sent_at < 2.hours.ago
  	    redirect_to new_password_reset_path, :alert => "Password reset has expired."
  	  else
        begin
    	    @user.password = params[:school_admin][:password]
    	    @user.save!
        rescue Exception => ex 
          errors << ex.message
  	    end 
        errors << "Invalid old password" unless @user.valid_password?(params[:school_admin][:password])

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
    if params[:teacher][:password] == params[:teacher][:password_confirmation]
      if @teacher.reset_password_sent_at < 2.hours.ago
        redirect_to new_password_reset_path, :alert => "Password reset has expired."
      else
        begin
          @teacher.password = params[:teacher][:password]
          @teacher.save!  
        rescue Exception => ex
          errors << ex.message
        end
        errors << "Invalid old password" unless @teacher.valid_password?(params[:teacher][:password])
        
        if errors.blank?
          redirect_to root_url, :notice => "Password has been reset!"
        else
          render :edit, :alert => "Password  is not valid"
        end
      end
    else
      flash[:password_mismatch] = "Password does not match. Try again"
      render :edit    end
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
end
