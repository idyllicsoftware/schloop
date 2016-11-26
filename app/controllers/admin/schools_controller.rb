class Admin::SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:show]
  layout "admin"

  def index
    ### TODO KAPIL CHECK PRODUCT ADMIN ROLE FOR THIS ACTION
    @grades = MasterGrade.all.select(:id, :name)
    @subjects = MasterSubject.all.select(:id, :name)
    @categories = Category.all.select(:id, :name).where(category_type: Category.category_types[:activity])
  end

  def all
    ### TODO KAPIL CHECK PRODUCT ADMIN ROLE FOR THIS ACTION
    schools = School.select(:id, :name, :code, :board, :principal_name, :website, :address, :zip_code, :phone1, :phone2).order('created_at').all
    render :json => {success: true, schools: schools}
  end

  def show
    redirect_to admin_schools_path and return if @school.blank?
    @js_data = {
        school_id: params[:id]
    }
    @grades = Grade.where(school_id: params[:id])
    @master_grades = MasterGrade.all.select(:id, :name)
    @master_subjects = MasterSubject.all.select(:id, :name)
  end

	def create
    response = create_school(school_params, school_admin_params)
    render :json => response
	end

  private

  def find_school
      @school = School.find_by(id: params[:id])
  end

  def create_school(school_datum, school_admin_datum)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        school = create_school!(school_datum)
        if school.save
          school_admin = create_school_admin!(school, school_admin_datum)
          if school_admin.save
            Admin::AdminMailer.welcome_message(school_admin.email, school_admin.first_name, school_admin.password).deliver_now
          else
            errors += school_admin.errors.full_messages
            raise('custom_errors')
          end
        else
          errors += school.errors.full_messages
          raise('custom_errors')
        end
      rescue Exception => ex
        if ex.message != 'custom_errors'
          errors << 'Something went wrong. Please contact dev team.'
          Rails.logger.debug("Exception in creating school: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
        end
        raise ActiveRecord::Rollback
      end
    end

    return {success: errors.blank?, errors: errors}
  end

  def create_school!(datum)
    create_params = {
        name: datum[:name],
        board: datum[:board],
        principal_name: datum[:authority_name],
        website: datum[:website],
        address: datum[:address],
        zip_code: datum[:zip_code],
        phone1: datum[:phone1],
        phone2: datum[:phone2],
        logo: datum[:logo]
    }
    return School.create(create_params)
  end

  def create_school_admin!(school, datum)
    create_params = {
        first_name: datum[:first_name],
        last_name: datum[:last_name],
        email: datum[:email],
        cell_number: datum[:cell_number],
        password: Devise.friendly_token.gsub('-','').first(6)
    }
    return school.school_admins.create(create_params)
  end

  def school_admin_params
    params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
  end

  def school_params
    params.require(:school).permit(:name, :board, :authority_name, :website, :address, :zip_code, :phone1, :phone2, :logo)
  end
end
