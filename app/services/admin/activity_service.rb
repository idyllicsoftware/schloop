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
            errors << 'Please enter chaaracters less than 1000 for field ' + field.humanize
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
                         .includes(:categories, :master_grade, :master_subject)
                         .select(:id, :title, :topic, :master_grade_id, :master_subject_id, :updated_at)
                         .order('activities.created_at desc')
    filtered_activities = []
    activities.each do |activity|
      filtered_activities << {
        id: activity.id,
        title: activity.title,
        topic: activity.topic,
        updated_at: activity.updated_at.strftime('%b, %d %Y'),
        grade: activity.master_grade.name,
        subject: activity.master_subject.name,
        categories: activity.categories.map(&:name)
      }
    end
    filtered_activities
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
