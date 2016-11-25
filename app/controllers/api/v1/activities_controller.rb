class Api::V1::ActivitiesController < Api::V1::BaseController

  # input case 1: grade_id,
  # input case 2: grade_id, subject_id, page
	def index
    errors = []
    grade_id = params[:grade_id]
    subject_id = params[:subject_id]
    page = params[:page].to_s.to_i

    @school = School.find_by(id: @current_user.school_id)
    page = params[:page].to_s.to_i
    page_size = 20
    offset = (page * page_size)

    grade = Grade.find_by(id: grade_id)
    errors << "Grade not found" if grade.blank?

    master_grade = grade.master_grade rescue nil
    errors << "Master Grade not found" if master_grade.blank?

    if errors.blank?
      master_subject_id = Subject.find(id: subject_id).master_subject.id rescue nil
      search_params = {master_grade_id: master_grade.id}
      search_params.merge!(master_subject_id: master_subject_id) if master_subject_id.present?
      activities_data, total_records = Activity.grade_activities(search_params, page_size, offset)
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

end
