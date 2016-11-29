class Admin::ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_activity, only: [:show, :deactivate, :upload_file]

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

  def show
    thumbnail_file = {}
    @activity.get_thumbnail_file.select(:original_filename, :name).each do |file|
      thumbnail_file[:s3_url] = file.name
      thumbnail_file[:original_filename] = file.original_filename
    end
    reference_files = []
    @activity.get_reference_files.select(:original_filename, :name).each do |file|
      reference_files << { s3_url: file.name, original_filename: file.original_filename }
    end
    activity_datum = {
      master_grade_id: @activity.master_grade_id,
      master_subject_id: @activity.master_subject_id,
      topic: @activity.topic,
      title: @activity.title,
      teaches: @activity.teaches,
      pre_requisite: @activity.pre_requisite,
      details: @activity.details,
      categories: @activity.categories.map(&:id),
      thumbnail_file: @activity.thumbnail_file,
      reference_files: @activity.reference_files
    }
    render json: {
      success: true,
      activity: activity_datum
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
