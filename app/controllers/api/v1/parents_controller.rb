class Api::V1::ParentsController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register, :login]

  def login
    parent = Parent.find_by_email(params[:parent][:email])
    if parent.present? && parent.valid_password?(params[:parent][:password])
      parent.sign_in_count += 1
      parent.save
      login_response = {
        success: true,
        error: nil,
        data: {
          id: parent.id,
          first_name: parent.first_name,
          last_name: parent.last_name,
          token: parent.token,
          first_sign_in: (parent.sign_in_count <= 1)
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

    @current_user.password = params[:new_password] if errors.blank?
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
    parent = @current_user

    students_data = []
    students = parent.students.includes(:student_profiles)
    students.each do |student|
      student_profile = student.student_profiles.last
      students_data << {
        school_id: student.school_id,
        first_name: student.first_name,
        last_name: student.last_name,
        middle_name: student.middle_name,
        grade: {id: student_profile.grade.id, name: student_profile.grade.name},
        division: {id: student_profile.division.id, name: student_profile.division.name}
      }
    end

    parent_profile = {
      id: parent.id,
      first_name: parent.first_name,
      last_name: parent.last_name,
      email: parent.email,
      phone: parent.cell_number,
      students: students_data
    }
    render json: {
      success: true,
      error: nil,
      data: parent_profile
    }
  end

  private
end