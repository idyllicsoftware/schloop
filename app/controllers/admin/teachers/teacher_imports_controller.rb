class Admin::Teachers::TeacherImportsController < ApplicationController
	before_action :authenticate_user!
	def new
    @teacher_import = TeacherImport.new
  end

  def create
    @teacher_import = TeacherImport.new(params[:teacher_import])
    if @teacher_import.save
      redirect_to root_url, notice: "Imported teachers successfully."
    else
      render :new
    end
  end
end
