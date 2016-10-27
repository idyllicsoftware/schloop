class Admin::SchoolsController < ApplicationController
	def new
	end

	def create
    new_school = School.new(school_params)
    if new_school.save
    	redirect_to admin_school_admins_path
    else
    	render 'new'
    end
	end

  def edit
    @user = current_user
    @school = School.where(id: @user.school_id).take
    @school_admins = User.where(school_id: @school.id)
  end

  private

  def school_params
    params.require(:school).permit(:name, :address, :zip_code, :phone1, :phone2, :website, :code)
  end     
end
