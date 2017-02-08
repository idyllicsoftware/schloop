class Api::V1::ParentsController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register, :login, :forgot_password]

  def login
    parent = Parent.find_by_email(params[:parent][:email])
    if parent.present? && parent.valid_password?(params[:parent][:password])
      if parent.active?
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
                message: "Your account has been deactivated."
            },
            data: nil
        }
      end
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
    error = nil
    if parent.active?
      students_data = []
      students = parent.students.active.includes(:student_profiles)
      students.each do |student|
        student_profile = student.student_profiles.last
        students_data << {
          id: student.id,
          school_id: student.school_id,
          school_name: student.school.name,
          first_name: student.first_name,
          last_name: student.last_name,
          middle_name: student.middle_name,
          grade: {id: (student_profile.grade.id rescue 0), name: (student_profile.grade.name rescue "-")},
          division: {id: (student_profile.division.id rescue 0), name: (student_profile.division.name rescue "-")}
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
    else
      parent_profile = {}
      error = "Your account has been deactivated."
    end
    render json: {
      success: error.blank?,
      error:  {
          code: 0,
          message: error
      },
      data: parent_profile
    }
  end

  def forgot_password
    errors = []
    parent = Parent.find_by(email: params[:email])
    if parent.present?
      parent.send_password_reset 
      response =  { success: true, 
                    error: errors,
                    data: { message: "Password reset instruction sent to your email" }
                  }
    else
      errors << "parent with given email id not found"
      response = { success: false, error: errors }
    end
    render json: response
  end

  def circulars
    errors, circular_data = [], []

    @student = Student.where(id: params[:student_id]).active.first
    errors << "Student not found" if @student.blank?

    school = @student.school
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last
    errors << "Student Grade Division information not found" if @student_profile.blank?

    page = params[:page].to_s.to_i
    page_size = 20
    offset = (page * page_size)

    circular_data, total_records = Ecircular.school_circulars(school, @current_user, filter_params, offset, page_size) if errors.blank?

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

  def circular
    errors = []

    @student = Student.where(id: params[:student_id]).active.first
    errors << "Student not found" if @student.blank?

    school = @student.school
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last
    errors << "Student Grade Division information not found" if @student_profile.blank?

    ecircular = Ecircular.find_by(id: params[:id])
    errors << "Ecircular not found" if ecircular.blank?

    is_circular_for_parent = EcircularParent.where(parent_id: @current_user.id).where(ecircular_id: params[:id]).present?
    is_circular_for_student = EcircularRecipient.where(division_id: @student_profile.division_id).present?

    unless is_circular_for_parent || is_circular_for_student
      errors << "Specified Circular is not available for you"
    end

    circular_parents_by_ecircular_id = EcircularParent.where(ecircular_id: params[:id]).group_by{|x| x.ecircular_id}
    circular_data = ecircular.data_for_circular(circular_parents_by_ecircular_id)

    if errors.blank?
      show_response = {
        success: true,
        error: nil,
        data: {
            circulars: circular_data
        }
      }
    else
      show_response = {
        success: false,
        error:  {
            code: 0,
            message: errors.flatten
        },
        data: nil
      }
    end
    render json: show_response
  end

  def activities
    errors, search_params = [], {}
    @student = Student.where(id: params[:student_id]).active.first 
    errors << "Student not found" if @student.blank?

    school = @student.school rescue nil
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last rescue nil
    errors << "Student Grade Division information not found" if @student_profile.blank?

    page = params[:page]
    page_size = 20
    category_ids = params[:category_ids]

    student_grade = @student_profile.grade rescue nil

    associated_activity_ids = ActivityShare.where(
      school_id: school.id,
      grade_id: student_grade.id,
      division_id: @student_profile.division_id).pluck(:activity_id).uniq rescue nil

    if errors.blank?
      subjects_by_master_id = student_grade.subjects.index_by(&:master_subject_id)

      mapping_data = {
        master_grade_id_grade_id: {student_grade.master_grade_id => student_grade},
        subjects_by_master_id: subjects_by_master_id
      }

      search_params[:id] = associated_activity_ids

      category_ids = category_ids.split(',').map(&:to_i) if category_ids.present?
      activities_data, total_records = Activity.grade_activities(search_params, mapping_data, page, category_ids, @current_user)
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

  def activity
    errors = []
    @student = Student.where(id: params[:student_id]).active.first
    if @student.blank?
      errors << "Student not found"
      render json: {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      } and return
    end

    school = @student.school
    errors << "Student School not found" if school.blank?

    @student_profile = @student.student_profiles.last
    errors << "Student Grade Division information not found" if @student_profile.blank?

    student_grade = @student_profile.grade

    activity = Activity.find_by(id: params[:id])
    errors << "Specified Activity not found" if activity.blank?

    errors << "Specified Activity not active" if activity.inactive?

    is_activity_shared = ActivityShare.where(activity_id: params[:id]).present?
    errors << "Specified Activity not available for you" unless is_activity_shared

    if errors.blank?
      subjects_by_master_id = student_grade.subjects.index_by(&:master_subject_id)
      mapping_data = {
          master_grade_id_grade_id: {student_grade.master_grade_id => student_grade},
          subjects_by_master_id: subjects_by_master_id
      }
      activities_data =  activity.data_for_activity(mapping_data)
    end

    if errors.blank?
      show_response = {
          success: true,
          error: nil,
          data: {
              activities: activities_data
          }
      }
    else
      show_response = {
          success: false,
          error:  {
              code: 0,
              message: errors.flatten
          },
          data: nil
      }
    end
    render json: show_response
  end

  def circular_read
    errors = []
    circular_id = params[:id]
    circular = Ecircular.find_by(id: circular_id)

    errors << "Invalid circular to track" if circular.blank?
    errors += Tracker.track(circular, @current_user, 'read') if errors.blank?
    render json: {
        success: errors.blank?,
        error:  errors,
        data: nil
    }
  end

    private
    def filter_params
      parent_circular_ids = EcircularParent.where(parent_id: @current_user.id).where(student_id: @student.id).pluck(:ecircular_id)
      default_division_id = @student_profile.division_id
      division_circular_ids = Ecircular.joins(:ecircular_recipients).where("ecircular_recipients.division_id IN (#{default_division_id})").ids

      circular_ids = (parent_circular_ids + division_circular_ids)

      filter_hash = {id: circular_ids}
      filters = params[:filter]
      return filter_hash if filters.blank?

      return {
        id: circular_ids,
        from_date: filters[:from_date],
        to_date: filters[:to_date],
        tags: filters[:tags]
      }
    end
end