class Api::V1::EcircularsController < Api::V1::BaseController

  # circulars = [
  #   {
  #     id: 1,
  #     title: 'title',
  #     body: 'body',
  #     created_by: 'Kapil Bhosale'
  #     created on: 'Oct 18, 2016, 4:12 PM'
  #     circular_tag: {
  #       id: 2,
  #       name: 'Holiday'
  #     },
  #     recipients:[
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]},
  #       {grade_id: 2, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]}
  #     ],
  #     attachments: [
  #       {original_file_name: 'file 1', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 2', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 3', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'}
  #     ]
  #   },
  #   {
  #     id: 2,
  #     title: 'title',
  #     body: 'body',
  #     created_by: 'Kapil Bhosale'
  #     created on: 'Oct 18, 2016, 4:12 PM'
  #     circular_tag: {
  #       id: 2,
  #       name: 'Holiday'
  #     },
  #     recipients:[
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]},
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]}
  #     ],
  #     attachments: [
  #       {original_file_name: 'file 1', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 2', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 3', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'}
  #     ]
  #   }
  # ]
  def index
    errors, circular_data = [], []
    @school = School.find_by(id: @current_user.school_id)
    page = params[:page].to_s.to_i
    page_size = 20
    offset = (page * page_size)
    if @school.blank?
      errors << "school not found."
    else
      circular_data, total_records = Ecircular.school_circulars(@school, @current_user, filter_params, offset, page_size)
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

    ecircular = Ecircular.find_by(id: params[:id])
    errors << "Ecircular not found" if ecircular.blank?

    is_circular_for_teacher = EcircularTeacher.where(teacher_id: @current_user.id).where(ecircular_id: params[:id]).present?

    unless is_circular_for_teacher
      errors << "Specified Circular is not available for you"
    end

    circular_teachers_by_ecircular_id = EcircularTeacher.where(ecircular_id: params[:id]).group_by{|x| x.ecircular_id}
    circular_data = ecircular.data_for_circular({}, circular_teachers_by_ecircular_id)

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

  # params to create ecircular
  # {
  #   title: string,
  #   body: string,
  #   circular_tag:
  #   recipients: {
  #     grade1_id: [div1_id, div2_id],
  #     grade2_id: [div1_id, div2_id]
  #   },
  #   attachments: [
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'},
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'},
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'}
  # ]
  # }
  def create
    errors = []
    user_type = @current_user.type rescue ''
    if user_type == 'ProductAdmin'
      created_by_type = Ecircular.created_by_types[:product_admin]
    elsif user_type == 'SchoolAdmin'
      created_by_type = Ecircular.created_by_types[:school_admin]
    else
      created_by_type = Ecircular.created_by_types[:teacher]
    end

    circular = Ecircular.create(circular_params.merge!(created_by_type: created_by_type, created_by_id: @current_user.id, school_id: @current_user.school_id ))
    if circular.persisted?
      begin
        if params[:recipients].present?
          # add ecircular recipients
          circular.ecircular_recipients.create!(recipients_params)
          division_ids = circular.ecircular_recipients.pluck(:division_id)
          student_ids = StudentProfile.active.where(division_id: division_ids).pluck(:student_id)
          student_ids = Student.where(id: student_ids).active.ids
          circular.send_notification(student_ids)
        elsif params[:students].present?
          # add ecircular parent recipents
          circular.ecircular_parents.create!(parents_params)
          student_ids = circular.ecircular_parents.pluck(:student_id)
          student_ids = Student.where(id: student_ids).active.ids
          circular.send_notification(student_ids)
        elsif params[:teachers]
          # add ecircular teachers recipents
          circular.ecircular_teachers.create!(teachers_params)
        end
        Attachment.create!(attachments_params(circular))
      rescue Exception => ex
        errors << ex.message
      end
    else
      errors << circular.errors.full_messages
    end

    if errors.blank?
      create_response = {
        success: true,
        error:  nil,
        data: {}
      }
    else
      create_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
    render json: create_response
  end

  def tags
    tags_data = []
    Ecircular.circular_tags.invert.each do |key, value|
      tags_data << {id: key, name: value.humanize}
    end

    render json: {
      success: true,
      error: nil,
      data: {
        tags: tags_data
      }
    }
  end

  def circular_teachers
    errors, teachers_data = [], {}
    teacher = @current_user
    grade_ids = teacher.grade_teachers.pluck(:grade_id)
    errors << "no grade is assigned to teacher" if grade_ids.blank?
    if errors.blank?
      teachers_data = Teacher.joins(:grade_teachers)
                        .where("grade_teachers.grade_id IN (#{grade_ids.join(',')}) AND grade_teachers.teacher_id != #{teacher.id}")
                        .distinct
                        .select(:id, :first_name, :last_name)
    end
    render json: { success: errors.blank?, error: errors, data: { teachers_data: teachers_data }}
  end

  private
  def circular_params
    params.permit(:title, :body, :circular_tag)
  end

  def recipients_params
    create_params = []
    params[:recipients].each do |grade_id, division_ids|
      division_ids.each do |div_id|
        create_params << {
          school_id: @current_user.school_id,
          grade_id: grade_id,
          division_id: div_id
        }
      end
    end
    return create_params
  end

  def parents_params
    create_parent_params = []
    students = Student.where(id: params[:students]).active
    students.each do |student|
      create_parent_params << {
        student_id: student.id,
        parent_id: student.parent_id
      }
    end
    return create_parent_params
  end

  def teachers_params
    create_teachers_params = []
    teachers = Teacher.where(id: params[:teachers])
    teachers.each do |teacher|
      create_teachers_params << {
        teacher_id: teacher.id,
        school_id: teacher.school_id
      }
    end
    return create_teachers_params
  end

  def attachments_params(circular)
    create_params = []
    return create_params if params[:attachments].blank?
    params[:attachments].each do |attachment|
      create_params << {
        attachable_id: circular.id,
        attachable_type: circular.class,
        name: attachment[:s3_url],
        original_filename: attachment[:original_file_name],
      }
    end
    return create_params
  end

  def filter_params
    default_division_ids = @current_user.grade_teachers.pluck(:division_id)
    circular_ids = Ecircular.joins(:ecircular_recipients).where("ecircular_recipients.division_id IN (#{default_division_ids.join(',')})").ids
    circular_ids += Ecircular.where(created_by_type: @current_user.class.name, created_by_id: @current_user.id).ids
    circular_ids += EcircularTeacher.where(teacher_id: @current_user.id).pluck(:ecircular_id)

    filters = params[:filter]
    return {id: circular_ids} if filters.blank?


    division_ids = []
    if filters[:grades].present?
      filters[:grades].each do |_, division_data|
        division_ids << division_data
      end
    end

    division_ids.flatten!

    if division_ids.present?
      division_ids &= default_division_ids
    else
      division_ids = default_division_ids
    end

    circular_ids = Ecircular.joins(:ecircular_recipients).where("ecircular_recipients.division_id IN (#{division_ids.join(',')})").ids if division_ids.present?

    {
      id: circular_ids,
      from_date: filters[:from_date],
      to_date: filters[:to_date],
      tags: filters[:tags]
    }
  end

end