class Admin::SchoolsController < ApplicationController
	
  layout "admin"
  
  def new
	end

	def create
    new_school_admin = SchoolAdmin.new
    new_school_admin.first_name = params[:administrator_name]
    if new_school_admin.save
      id = new_school_admin.id
    else
      render dashboards_admin_dashboard_admin_users_path
    end
    new_school = School.new
    new_school.name = params[:school][":name"]
    new_school.website = params[:school][":website"]
    new_school.address = params[:school][":address"]
    new_school.zip_code = params[:school][":zip_code"]
    new_school.phone1 = params[:school][":phone1"]
    new_school.phone2 = params[:school][":phone2"]
    new_school.school_director_id = id
    new_school.board = params[:school][":board"]
    new_school.principal_name = params[:school][":authority_name"]

    if new_school.save
    	redirect_to admin_school_admins_path
    else
    	render dashboards_admin_dashboard_admin_users_path
    end
	end

  def edit

  end
    
  private

  def school_params
    params.permit(:name, :address, :zip_code, :phone1, :phone2, :website)
  end     
end
