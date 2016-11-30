class Admin::ActivityService < BaseService
  def validate_params(params)
    char_limit_50_fields = %w(topic title)
    char_limit_1000_fields = %w(details pre_requisite)
    mandatory_fields = %w(master_grade_id master_subject_id topic title categories)
    errors = []
    %w(master_grade_id master_subject_id topic title categories).each do |field|
      errors << 'Please enter a valid ' + field.humanize unless params[field].present?
    end
    if errors.empty?
      params.each do |field, value|
        if mandatory_fields.include?(field)
          if value.blank?
            errors << 'Please enter a valid value for field ' + field.humanize
            next
          end
        end

        if char_limit_1000_fields.include?(field)
          if value.length > 1000
            errors << 'Please enter characters less than 1000 for field ' + field.humanize
            next
          end
        end

        next unless char_limit_50_fields.include?(field)
        if value.length > 50
          errors << 'Please enter chaaracters less than 50 for field ' + field.humanize
          next
        end
      end
    end
    { errors: errors, data: [] }
  end

  def get_activities(filter_options)
    filter_options ||= []
    filter_query = build_search_query(filter_options)
    activities = Activity.where(filter_query)
                         .includes(:categories, :master_grade, :master_subject, :attachments)
                         .order('activities.created_at desc')
    filtered_activities = []
    activities.each do |activity|
      thumbnail_file = {}
      activity.get_thumbnail_file.each do |file|
        thumbnail_file[:s3_url] = file.name
        thumbnail_file[:original_filename] = file.original_filename
      end
      reference_files = []
      activity.get_reference_files.select(:original_filename, :name).each do |file|
        reference_files << { s3_url: file.name, original_filename: file.original_filename }
      end
      filtered_activities << {
        id: activity.id,
        title: activity.title,
        topic: activity.topic,
        updated_at: activity.updated_at.strftime('%b, %d %Y'),
        grade: activity.master_grade.name,
        subject: activity.master_subject.name,
        categories: activity.categories.map(&:name),
        status: activity.active? ? true : false,
        master_grade_id: activity.master_grade_id,
        master_subject_id: activity.master_subject_id,
        category_ids: activity.categories.map(&:id),
        topic: activity.topic,
        teaches: activity.teaches,
        pre_requisite: activity.pre_requisite,
        details: activity.details,
        thumbnail_file: thumbnail_file,
        reference_files: reference_files
      }
    end
    filtered_activities
  end

  def upload_file(activity, file, type)
    file_upload_service = FileUploadService.new
    response = file_upload_service.upload_file_to_s3(file, activity, sub_type: Activity.file_sub_types[type])
    {
      errors: response[:errors],
      data: response[:data]
    }
  end

  private

  def build_search_query(filter_options)
    filter_query = {}
    filter_options.each do |attribute, value|
      if %w(master_grade_id master_subject_id).include?(attribute)
        filter_query[attribute] = value
      elsif attribute == 'categories'
        filter_query['categories.id'] = value
      end
    end
    filter_query
  end
end
