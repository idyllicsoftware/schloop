class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user

    mail to: @user.email, subject: "password reset"
  end

  def teacher_password_reset(teacher)
    @teacher = teacher

    mail to: @teacher.email, subject: "password reset"
  end

  def parent_password_reset(parent)
    @parent = parent

    mail to: @parent.email, subject: "password reset"
  end
end
