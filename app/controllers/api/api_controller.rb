class Api::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_default_response_format
  after_filter :log_response

  def authenticate
    authenticate_token || render_unauthorized
    check_validity_of_user
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(user_token: token)
      @current_user = Teacher.find_by(token: token) if @current_user.nil?
    end
    return @current_user
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: :unauthorized
  end

  def check_validity_of_user
    re_login_required = false
    if @current_user.is_a?(Teacher) and @current_user.no_grade_assigned?
      re_login_required = true
    elsif @current_user.is_a?(Parent) and !@current_user.active
      re_login_required = true
    end
    render json: 'Important data changed, Need to Re-login', status: :unauthorized if re_login_required
  end

  def set_default_response_format
    request.format = :json
  end

  def log_response
    Rails.logger.info { "------------- Response: #{response.body.inspect} ------------" }
  end

end
