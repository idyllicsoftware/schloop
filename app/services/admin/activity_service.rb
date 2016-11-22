class Admin::ActivityService < BaseService

  def validate_params(params)
    char_limit_50_fields = %w(topic title)
    char_limit_1000_fields = %w(details pre_requisite)
    mandatory_fields = %w(topic title grade subject category)
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

      if char_limit_50_fields.include?(field)
        if value.length > 1000
          errors << 'Please enter chaaracters less than 50 for field ' + field.humanize
          next
        end
      end

      if field == 'subject'
        if Content.subjects[value].nil?
          errors << 'invalid ' + field.humanize
          next
        end
      end

      if field == 'grade'
        if Content.grades[value].nil?
          errors << 'invalid ' + field.humanize
          next
        end
      end
    end
    { errors: errors, data: [] }
  end
end
