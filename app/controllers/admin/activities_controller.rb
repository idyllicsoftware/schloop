class Admin::ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_activity, only: [:update]

  def create
    activity_service = Admin::ActivityService.new
    activity_params = get_activity_params(params)
    validate_response = activity_service.validate_params(activity_params)
    if validate_response[:errors].present?
      render json: { errors: validate_response[:errors] } and return
    end
    response = Activity.create_activity(activity_params)
    render json: { errors: response[:errors] }
  end

  # def update
  #   activity_service = Admin::ActivityService.new
  #   activity_params = get_activity_params(params)
  #   validate_response = activity_service.validate_params(activity_params)
  #   if validate_response[:errors].present?
  #     render json: { errors: validate_response[:errors] } and return
  #   end

  #   response = @activity.update_activity(activity_params)
  #   render json: { errors: response[:errors] }
  # end

  def all
    activity_service = Admin::ActivityService.new
    activities = activity_service.get_activities(params[:filter])
    render json: {
      success: true,
      activities: activities
    }
  end

  private

  def load_activity
    @activity = Activity.find_by(id: params[:id])
  end

  def get_activity_params(params)
    params.require(:activity).permit(:master_grade_id, :master_subject_id, :topic, :title, :teaches,
                                     :pre_requisite, :details, :reference_files, :thumbnail_file, categories: [])
  end
end
