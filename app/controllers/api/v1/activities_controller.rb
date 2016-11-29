class Api::V1::ActivitiesController < Api::V1::BaseController

  # input case 1: grade_id,
  # input case 2: grade_id, subject_id, page
	def index
    errors = []
    grade_id = params[:grade_id]
    subject_ids = params[:subject_ids]
    category_ids = params[:category_ids]
    page = params[:page]
    page_size = 20

    grade = Grade.find_by(id: grade_id)
    errors << "Grade not found" if grade.blank?

    master_grade = grade.master_grade rescue nil
    errors << "Master Grade not found" if master_grade.blank?

    if errors.blank?
      search_params = {master_grade_id: master_grade.id}
      mapping_data = {
        master_grade_id_grade_id: {master_grade.id => grade}
      }
      if subject_ids.present?
        subject_ids = subject_ids.split(',')
        subjects_by_master_id = Subject.where(id: subject_ids).index_by(&:master_subject_id) rescue nil
        master_subject_ids = subjects_by_master_id.keys rescue []
        search_params.merge!(master_subject_id: master_subject_ids)
        mapping_data[:subjects_by_master_id] = subjects_by_master_id
      end

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
            current_page: (page || 0)
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

  def get_categories
    activity_categories = Category.select(:id, :name)
    render json: {
      success: true,
      error: nil,
      data: activity_categories
    }
  end

  # recipuets: {
  # grade_id: [div_id1, div_id2]
  # grade_id: [div_id1, div_id2]
  # }
  # "recipients": {
  #   "1": [1, 2],
  #   "2": [3, 4]
  # }
  def share

  end

end
