class Admin::GradesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create]
  layout "admin"

  def index
    render json: {success: false, errors: ['School not found']} and return if @school.blank?

    render json: {success: true, grades: []}
  end

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    response = create_grades(params[:school_id],params[:grade_name])
    #response = create_school_admin(@school, create_grades)
     render :json => response
  end

  def add_subject
  end

  private

  def find_school
    @school = School.find_by(id: params[:school_id])
  end

  def create_grades(id,name)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        grade = Grade.create(name: name, school_id: id)
      rescue Exception => ex
        if ex.message != 'custom_errors'
          errors << 'Something went wrong. Please contact dev team.'
          Rails.logger.debug("Exception in creating grade: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
        end
        raise ActiveRecord::Rollback
      end
    end

    return {success: errors.blank?, errors: errors}
  end

  def create_school_admin_params
    params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
  end

end