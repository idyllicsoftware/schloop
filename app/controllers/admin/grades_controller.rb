class Admin::GradesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create]
  before_action :find_grades, only: [:index, :create]
  layout "admin"

  def index
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    grade_data = []
    @grades.each do |grade|
      subjects, divisions = [], []
      grade.subjects.each {|subject| subjects << {subject_id: subject.id, subject_name: subject.name} }
      grade.divisions.each {|division| divisions << {division_id: division.id, division_name: division.name} }
      grade_data << {
        grade_id: grade.id,
        grade_name: grade.name,
        subjects: subjects,
        divisions: divisions
      }
    end
    render json: {success: true, grades: grade_data}
  end

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    response = create_grades(params[:school_id],params[:grade_name])
    render :json => response
  end

  private

  def find_grades
    @grades = Grade.where(school_id: params[:school_id]).includes(:subjects, :divisions)
  end
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

    return {success: errors.blank?, errors: errors, grade_name: name}
  end

  def create_school_admin_params
    params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
  end

end
