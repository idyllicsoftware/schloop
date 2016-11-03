class Admin::SchoolsController < ApplicationController
	
  layout "admin"
  
  def new
	end

	def create
    new_school_admin = SchoolAdmin.new
    new_school_admin.first_name = params[:administrator][:first_name]
    new_school_admin.last_name = params[:administrator][:last_name]
    new_school_admin.email = params[:email]
    new_school_admin.cell_number = params[:phone]
    new_school_admin.password = "12345678"
    new_school_admin.password_confirmation = "12345678"
    if new_school_admin.save!
      id = new_school_admin.id
    end
    new_school = School.new
    new_school.name = params[:school][":name"]
    new_school.website = params[:school][":website"]
    new_school.address = params[:school][":address"]
    new_school.zip_code = params[:school][":zip_code"]
    new_school.phone1 = params[:school][":phone1"]
    new_school.phone2 = params[:school][":phone2"].to_i if params[:school][":phone2"].present?
    new_school.school_director_id = id
    new_school.board = params[:school][":board"]
    new_school.principal_name = params[:school][":authority_name"]

    if new_school.save!
      Admin::AdminMailer.welcome_message(new_school_admin.email, new_school_admin.first_name, new_school_admin.password).deliver_now
    	redirect_to admin_school_admins_path
    else
    	render dashboards_admin_dashboard_admin_users_path
    end
	end

  def edit
    @user = User.where(school_id:params[:id])
    @school = School.find(params[:id])
    @school_id = params[:id]
    @school_admins = User.where(school_id: @school.id)
  end

  def add_grade
    binding.pry
    new_grade = Grade.create(:name => params[:grade_name], :school_id => params[:school_id])
    redirect_to controller:'admin/schools',action: 'edit',id: params[:school_id]
  end

  private

  def school_params
    params.permit(:name, :address, :zip_code, :phone1, :phone2, :website)
  end     
end
