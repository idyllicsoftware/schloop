class Admin::UsersController < ApplicationController

  def update_password
    @user = current_user
    errors = []
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
    else
      errors = @user.errors.full_messages.join(",\n")
    end
    render json: {
        success: errors.blank?,
        errors: errors
      }
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
