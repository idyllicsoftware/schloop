class Admin::ParentImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:new, :create]
  layout "admin"

  def new
    redirect_to '/' and return if @school.blank?
    @grade = @school.grades.find(params[:grade_id])
    redirect_to admin_school_path(@school.id) and return if @grade.blank?
    @parent_import = ParentImport.new({}, @school.id, @grade.id)
  end

  def create
    redirect_to '/' and return if @school.blank?
    @grade = @school.grades.find(params[:grade_id])
    redirect_to admin_school_path(@school.id) and return if @grade.blank?
    @parent_import = ParentImport.new(params[:parent_import], params[:school_id], params[:grade_id])
    if @parent_import.save
      redirect_to admin_school_path(@school.id)
    else
      render :action => "new" #,:school_id => @school.id, :grade_id => @grade 
    end
  end

  private
  def find_school
    @school = School.find_by(id: params[:school_id])
  end

end
