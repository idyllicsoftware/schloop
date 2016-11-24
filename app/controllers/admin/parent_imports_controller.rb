class Admin::ParentImportsController < ApplicationController
  before_action :authenticate_user!
  layout "admin"
  def new
  	@school = School.find(params[:school_id])
    @grade = Grade.find(params[:grade_id])
    @parent_import = ParentImport.new({}, @school.id, @grade.id)
  end

  def create
    @school = School.find(params[:school_id])
    @grade = Grade.find(params[:grade_id])
    @parent_import = ParentImport.new(params[:parent_import], params[:school_id], params[:grade_id])
    if @parent_import.save
      redirect_to admin_school_path(@school.id)
    else
      render :action => "new" #,:school_id => @school.id, :grade_id => @grade 
    end
  end
end
