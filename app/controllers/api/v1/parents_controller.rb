class Api::V1::ParentsController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register, :login, :forgot_password]

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
          email: parent.email,
          phone: parent.cell_number,
          token: parent.user_token,
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
        id: student.id,
        school_id: student.school_id,
        school_name: student.school.name,
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

  def forgot_password
    render json: {
      success: true,
      error: nil,
      data: {
        message: "Password reset instruction sent to your email"
      }
    }
  end

  def circulars
    errors, circular_data = [], []

    @student = Student.find_by(id: params[:student_id])
    errors << "Student not found" if @student.blank?

    school = @student.school
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last
    errors << "Student Grade Division information not found" if @student_profile.blank?

    page = params[:page].to_s.to_i
    page_size = 20
    offset = (page * page_size)

    circular_data, total_records = Ecircular.school_circulars(school, filter_params, offset, page_size) if errors.blank?

    if errors.blank?
      index_response = {
        success: true,
        error: nil,
        data: {
          pagination_data: {
            page_size: page_size,
            record_count: total_records,
            total_pages: (total_records/page_size.to_f).ceil,
            current_page: page
          },
          circulars: circular_data
        }
      }
    else
      index_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
    render json: index_response
  end


  def activities
    errors, search_params = [], {}

    @student = Student.find_by(id: params[:student_id])
    errors << "Student not found" if @student.blank?

    school = @student.school
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last
    errors << "Student Grade Division information not found" if @student_profile.blank?

    page = params[:page]
    page_size = 20
    category_ids = params[:category_ids]

    student_grade = @student_profile.grade

    associated_activity_ids = ActivityShare.where(
      school_id: school.id,
      grade_id: student_grade.id,
      division_id: @student_profile.division_id).pluck(:activity_id).uniq

    if errors.blank?
      subjects_by_master_id = student_grade.subjects.index_by(&:master_subject_id)

      mapping_data = {
        master_grade_id_grade_id: {student_grade.master_grade_id => student_grade},
        subjects_by_master_id: subjects_by_master_id
      }

      search_params[:id] = associated_activity_ids

      category_ids = category_ids.split(',').map(&:to_i) if category_ids.present?
      activities_data, total_records = Activity.grade_activities(search_params, mapping_data, page, category_ids)
    end

    if errors.blank?
      index_response = {
        success: true,
        error: nil,
        data: {
          pagination_data: {
            page_size: page_size,
            record_count: total_records,
            total_pages: (total_records/page_size.to_f).ceil,
            current_page: (page || 0).to_i
          },
          activities: activities_data
        }
      }
    else
      index_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
    render json: index_response
  end

    private
    def filter_params
      filters = params[:filter]
      return {} if filters.blank?
      divisions = [@student_profile.division_id]

      {
        from_date: filters[:from_date],
        to_date: filters[:to_date],
        divisions: divisions,
        tags: filters[:tags]
      }
    end
end