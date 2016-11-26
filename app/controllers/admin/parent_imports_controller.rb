class Admin::ParentImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:new, :create]
  layout "admin"

  def new
    redirect_to '/' and return if @school.blank?
    @grade = @school.grades.find(params[:grade_id])
    redirect_to admin_school_path(@school.id) and return if @grade.blank?
    @js_data = {
        school_id: params[:school_id]
    }
  end

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    @grade = @school.grades.find(params[:grade_id])
    render json: {success: false, errors: ['Grade not found']} and return if @grade.blank?
    @parent_import = ParentImport.new(params[:parent_import], params[:school_id], params[:grade_id])
    if @parent_import.save
      render json: {success: true}
    else
      render json: {success: false, errors: @parent_import.errors.full_messages}
    end
  end

  private
  def find_school
    @school = School.find_by(id: params[:school_id])
  end

end
