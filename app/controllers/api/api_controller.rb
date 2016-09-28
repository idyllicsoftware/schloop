class Api::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_default_response_format
  after_filter :log_response

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |api_token, _options|
      @current_user = Devise.secure_compare(u.api_token, api_token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: :unauthorized
  end


  def set_default_response_format
    request.format = :json
  end

  def log_response
    Rails.logger.info { "------------- Response: #{response.body.inspect} ------------" }
  end

end
