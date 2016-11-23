class Admin::ParentImportsController < ApplicationController
  before_action :authenticate_user!
  layout "admin"
  def new
  	@school = School.find(params[:school_id])
    @parent_import = ParentImport.new({}, @school.id)
  end

  def create
    @school = School.find(params[:school_id])
    @parent_import = ParentImport.new(params[:parent_import], params[:school_id])
    if @parent_import.save
      redirect_to :back, notice: "Imported teachers successfully."
    else
      redirect_to :back, errors: "Please check csv data."
    end
  end
end
