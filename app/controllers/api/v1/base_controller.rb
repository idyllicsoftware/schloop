class Api::V1::BaseController < Api::ApiController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
end
