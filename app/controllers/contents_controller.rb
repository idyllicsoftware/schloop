class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_content, only: [:create_or_update]

  # def index
  #   @contents = Content.all
  # end

  def create_or_update
    content_service = ContentService.new
    content_params = get_content_params
    validate_response = content_service.validate_params(content_params)
    if validate_response[:errors].present?
      render json: { errors: validate_response[:errors], data: validate_response[:data] }
    end
    if @content
      response = @content.update_content(content_params)
    else
      response = Content.create_content(content_params)
    end
    render json: { errors: response[:errors], data: response[:data] }
  end

  private

  def load_content
    @content = Content.find_by(id: params[:id])
  end

  def get_content_params(params)
    params.require(:content).permit(:grade, :subject, :topic, :title, :categories, :teaches,
                                    :pre_requisite, :details, :attachment_id)
  end
end
