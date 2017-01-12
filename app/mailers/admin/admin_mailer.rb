class Admin::AdminMailer < ApplicationMailer

  def welcome_message(user_email, user_name, password, user_type)
    @url = MAILER_HOST
    @user_name = user_name
    @user_email = user_email
    @password = password
    @user_type = user_type
    mail(to: user_email, subject: "Welcome to Schloop...")
  end
end
