class PasswordResetsController < ApplicationController
  
  def create
    email = forget_password_params[:email]
    user_type = forget_password_params[:user_type]
    if user_type.eql?('SchoolAdmin')
      user_type = User.find_by(email: email)
    elsif user_type.eql?('Teacher')
      user = Teacher.find_by(email: email)
    else
      user = Parent.find_by(email: email)
    end  
    user.send_password_reset if user
    render json: {success:!user.nil?}
  end

  def edit
  	@user = Parent.find_by_reset_password_token!(edit_params[:format]) rescue nil
    @user = Teacher.find_by_reset_password_token!(edit_params[:format]) if @user.nil?
    @user = User.find_by_reset_password_token!(edit_params[:format]) if @user.nil?
  end

  def update
    errors = []
    begin
      @user = Teacher.find_by_reset_password_token!(update_params[:token])  rescue nil
      @user = Parent.find_by_reset_password_token!(update_params[:token]) if @user.nil?
      @user = User.find_by_reset_password_token!(update_params[:token]) if @user.nil?
      raise "Link is already used or expired.Generate new one" if @user.nil?
      if params[:user][:password] == params[:user][:password_confirmation]
        if @user.reset_password_sent_at < 2.hours.ago
          errors << "Password reset link has expired."
        else
          @user.password = update_params[:user][:password]
          @user.save!
          raise "Invalid password" unless @user.valid_password?(update_params[:user][:password])
        end
      else
        raise "Password does not match. Try again"
      end
    rescue Exception => e
      errors << e.message
    end
    render json: {success: errors.blank?, errors: errors,redirect_to: root_url}
  end
 
  private
  def forget_password_params
    params.permit(:email, :user_type)
  end

  def edit_params
    params.permit(:format)
  end

  def update_params
    params.permit({:user=> [:password,:password_confirmation]},:token)
  end
end
