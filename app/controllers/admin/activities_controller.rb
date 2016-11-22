class Admin::ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_activity, only: [:create_or_update]

  # def index
  #   @activitys = Activity.all
  # end

  def create_or_update
    activity_service = Admin::ActivityService.new
    activity_params = get_activity_params
    validate_response = activity_service.validate_params(activity_params)
    if validate_response[:errors].present?
      render json: { errors: validate_response[:errors], data: validate_response[:data] }
    end
    if @activity
      response = @activity.update_activity(activity_params)
    else
      response = Activity.create_activity(activity_params)
    end
    render json: { errors: response[:errors], data: response[:data] }
  end

  private

  def load_activity
    @activity = Activity.find_by(id: params[:id])
  end

  def get_activity_params(params)
    params.require(:activity).permit(:grade, :subject, :topic, :title, :categories, :teaches,
                                    :pre_requisite, :details, :attachments)
  end
end