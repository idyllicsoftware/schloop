class Admin::ActivityService < BaseService
  def validate_params(params)
    char_limit_50_fields = %w(topic title)
    char_limit_1000_fields = %w(details pre_requisite)
    mandatory_fields = %w(topic title)
    errors = []
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
      if value.length > 1000
        errors << 'Please enter chaaracters less than 50 for field ' + field.humanize
        next
      end
    end
    { errors: errors, data: [] }
  end

  def get_activities(filter_options)
    filter_options ||= []
    filter_query = build_search_query(filter_options)
    activities = Activity.includes(:categories).where(filter_query).select(:id, :title, :topic, :updated_at)
    filtered_activities = []
    activities.each do |activity|
      filtered_activities << {
        id: activity.id,
        title: activity.title,
        topic: activity.topic,
        updated_at: activity.updated_at.strftime('%b, %d %Y'),
        categories: activity.categories.pluck(:name)
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
