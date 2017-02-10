class Api::V1::TeachersController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register, :login, :forgot_password]

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
    errors = []
    teacher = Teacher.find_by_email(params[:teacher][:email])
    unless teacher.present? && teacher.valid_password?(params[:teacher][:password])
      errors << "Invalid credentials"
    end

    errors << "No Grade assigned to a teacher" if errors.blank? and teacher.grade_teachers.blank?

    if errors.blank?
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
          message: errors.join(",")
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

  def forgot_password
    errors = []
    teacher = Teacher.find_by(email: params[:email])
    if teacher.present?
      teacher.send_password_reset 
      response =  { success: true, 
                    error: errors,
                    data: { message: "Password reset instruction sent to your email" }
                  }
    else
      errors << "teacher with given email id not found"
      response = { success: false, error: errors }
    end
    render json: response
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

  def index
    teacher = @current_user
    student_name = params[:q]
    parents = teacher.associated_parents(student_name)
    render json: {
      success: true,
      error: nil,
      data: {
        parents: parents
      }
    }
  end

  def profile
    teacher = @current_user
    grades_data = teacher.grade_teachers.includes(:grade).group_by do |x| x.grade_id end
    profile_data ={}
    grades_data.each do |grade_id, datas|
      divisions, subjects = {}, {}
      datas.each do |data|
        profile_data[grade_id]||= {
          grade_id: grade_id,
          grade_name: data.grade.name
        }
        divisions[data.division.id] = { id: data.division.id, name: data.division.name }
        subjects[data.subject.id] = { id: data.subject.id, name: data.subject.name }
      end
      profile_data[grade_id][:divisions] = divisions.values
      profile_data[grade_id][:subjects] = subjects.values
    end
    profile_data = {
      id: teacher.id,
      first_name: teacher.first_name,
      last_name: teacher.last_name,
      email: teacher.email,
      phone: teacher.cell_number,
      school_id: teacher.school_id,
      grade_divisions: profile_data.values
    }

    render json: {
      success: true,
      error: nil,
      data: {
        profile: profile_data
      }
    }
  end

  def topics
    errors = []
    grade  = Grade.find_by(id: params[:grade_id])
    errors << "Please provide valid grade." if grade.nil?

    subject = Subject.find_by(id: params[:subject_id])
    errors << "Please provide valid subject." if subject.nil?

    if errors.blank?
      master_grade_id = grade.master_grade_id
      master_subject_id = subject.master_subject_id

      topics = Topic.index(@current_user, master_grade_id, master_subject_id)
      render json: {
          success: true,
          error: nil,
          data: {
              topics: topics
          }
      }
    else
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

  def create_topic
    errors = []
    grade  = Grade.find_by(id: params[:grade_id])
    errors << "Please provide valid grade." if grade.nil?

    subject = Subject.find_by(id: params[:subject_id])
    errors << "Please provide valid subject." if subject.nil?

    errors << "Topic cannot be blank." if params[:topic].blank?

    if errors.blank?
      master_grade_id = grade.master_grade_id
      master_subject_id = subject.master_subject_id

      topic = Topic.create(title: params[:topic], master_grade_id: master_grade_id,
      master_subject_id: master_subject_id, teacher_id: @current_user.id)

      render json: {
          success: true,
          error: nil,
          data: {
              topic: topic
          }
      }
    else
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

  def circular_read
    errors = []
    circular_id = params[:id]
    circular = Ecircular.find_by(id: circular_id)

    errors << "Invalid circular to track" if circular.blank?
    errors += Tracker.track(circular, @current_user, 'read', @current_user.class.to_s) if errors.blank?
    render json: {
        success: errors.blank?,
        error:  errors,
        data: nil
    }
  end

  private
  def teacher_params
    params.require(:teacher).permit(:email, :password, :first_name, :middle_name, :last_name, :cell_number)
  end
end
