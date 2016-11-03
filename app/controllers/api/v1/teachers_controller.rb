class Api::V1::TeachersController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register, :login]

  def register
    errors = []
    school = School.find_by(code: params[:teacher][:school_code])
    if school.nil?
      errors << "Invalid School code"
    else
      create_teacher_params = teacher_params.merge!(school_id: school.id)
      teacher = Teacher.create(create_teacher_params)
    end
    if teacher && teacher.errors.blank? && errors.blank?
      register_response = {
        success: true,
        error: nil,
        data: {
          id: teacher.id,
          token: teacher.token
        }
      }
    else
      errors += teacher.errors.full_messages if teacher.present?
      register_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end

    render json: register_response
  end

  def login
    teacher = Teacher.find_by_email(params[:teacher][:email])
    if teacher.present? && teacher.valid_password?(params[:teacher][:password])
      teacher.sign_in_count += 1
      teacher.save
      login_response = {
        success: true,
        error: nil,
        data: {
          id: teacher.id,
          token: teacher.token,
          first_sign_in: (teacher.sign_in_count <= 1)
        }
      }
    else
      login_response = {
        success: false,
        error:  {
          code: 0,
          message: "Invalid credentials"
        },
        data: nil
      }
    end

    render json: login_response
  end

  def reset_password
    @current_user.password = params[:new_password]
    if @current_user.save
      render json: {
        success: true,
        error: nil,
        data: {
          message: "Password changed successfully."
        }
      }
    else
      render json: {
        success: false,
        error:  {
          code: 0,
          message: @current_user.errors.full_messages.join(', ')
        },
        data: nil
      }
    end
  end

  def dashboard
    render json: {
      success: true,
      error: nil,
      data: {
        id: @current_user.id,
        email: @current_user.email,
        some_data: "You must see this after providing valid token."
      }
    }
  end

  private
  def teacher_params
    params.require(:teacher).permit(:email, :password, :first_name, :middle_name, :last_name)
  end
end
