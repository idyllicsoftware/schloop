class Admin::ActivitiesController < Admin::BaseController
  before_action :load_activity, only: [:deactivate, :upload_file]

  def create
    activity_service = Admin::ActivityService.new
    activity_params = get_activity_params(params)
    validate_response = activity_service.validate_params(activity_params)
    if validate_response[:errors].present?
      render json: { errors: validate_response[:errors] } and return
    end
    response = Activity.create_activity(activity_params)
    render json: { errors: response[:errors], activity_id: response[:data] }
  end

  def all
    activity_service = Admin::ActivityService.new
    activities = activity_service.get_activities(params[:filter])
    render json: {
      success: true,
      activities: activities
    }
  end

  def deactivate
    response = @activity.deactivate_activity
    render json: response
  end

  def upload_file
    activity_service = Admin::ActivityService.new
    response = activity_service.upload_file(@activity, params[:file], params[:type])
    render json: {
      success: response[:errors].blank?,
      errors: response[:errors],
      attachment_id: response[:data]
    }
  end

  private

  def load_activity
    @activity = Activity.find_by(id: params[:id])
    render json: { success: false, errors: ['Activity not found'] } and return if @activity.blank?
  end

  def get_activity_params(params)
    params.require(:activity).permit(:master_grade_id, :master_subject_id, :topic, :title, :teaches,
                                     :pre_requisite, :details, categories: [])
  end
end
