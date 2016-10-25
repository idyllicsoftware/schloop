class Admin::SchoolsController < ApplicationController
	
  layout "admin"
  
  def new
	end

	def create
    new_school_admin = SchoolAdmin.new
    new_school_admin.first_name = params[:administrator_name]

    new_school = School.new
    new_school.name = params[:name]
    new_school.website = params[:website]
    new_school.address = params[:address]
    new_school.zip_code = params[:zip_code]
    new_school.phone1 = params[:phone1]
    new_school.phone2 = params[:phone2]
    new_school.name = params[:name]

    if new_school.save
    	redirect_to admin_school_admins_path
    else
    	render 'new'
    end
	end

  def edit

  end
    
  private

  def school_params
    params.permit(:name, :address, :zip_code, :phone1, :phone2, :website)
  end     
end
