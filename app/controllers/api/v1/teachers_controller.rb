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
          first_name: teacher.first_name,
          last_name: teacher.last_name,
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
    errors = []
    old_password = params[:old_password]
    errors << "Invalid old password" unless @current_user.valid_password?(old_password)

    @current_user.password = params[:new_password]
    if @current_user.save && errors.blank?
      render json: {
        success: true,
        error: nil,
        data: {
          message: "Password changed successfully."
        }
      }
    else
      error_messages = @current_user.errors.full_messages.join(', ')
      errors << error_messages if error_messages.present?
      render json: {
        success: false,
        error:  {
          code: 0,
          message: errors
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


  def profile
    profile_data = {
      id: @current_user.id,
      first_name: @current_user.first_name,
      last_name: @current_user.last_name,
      email: @current_user.email,
      phone: @current_user.cell_number,
      school_id: @current_user.school_id,
      grade_divisions: [{grade_id: 1,
                       grade_name: 'grade one',
                       divisions: [
                        {id: 1, name: 'A'},
                        {id: 2, name: 'B'},
                        {id: 3, name: 'C'},
                        {id: 4, name: 'D'}] },
                      {grade_id: 2,
                       grade_name: 'grade two',
                       divisions: [
                         {id: 5, name: 'A'},
                         {id: 6, name: 'B'}] }]
    }

    render json: {
      success: true,
      error: nil,
      data: {
        profile: profile_data
      }
    }

  end

  private
  def teacher_params
    params.require(:teacher).permit(:email, :password, :first_name, :middle_name, :last_name)
  end
end
