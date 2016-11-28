class Admin::Teachers::TeacherImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:create]
  layout "admin"

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    @teacher_import = TeacherImport.new(params[:teacher_import], params[:school_id])
    if @teacher_import.save
      render json: {success: true}
    else
      render json: {success: false, errors: @teacher_import.errors.full_messages}
    end
  end

  private
  def find_school
    @school = School.find_by(id: params[:school_id])
  end

end