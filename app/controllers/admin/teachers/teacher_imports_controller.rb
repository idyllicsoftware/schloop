class Admin::Teachers::TeacherImportsController < ApplicationController
	before_action :authenticate_user!
  layout "admin"
	def new
    @teacher_import = TeacherImport.new
  end

  def create
    @school = School.find(params[:school_id])
    @teacher_import = TeacherImport.new(params[:teacher_import], params[:school_id])
    if @teacher_import.save
      redirect_to :back, notice: "Imported teachers successfully."
    else
      render :template => 'admin/schools/show'
    end
  end
end
