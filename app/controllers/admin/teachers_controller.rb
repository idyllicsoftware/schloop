class Admin::TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create]
  before_action :find_teacher, only: [:update, :destroy]
  layout "admin"


  def index
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    school_teachers = @school.teachers.select(:id, :first_name, :last_name, :cell_number, :email).order('created_at').all
    render json: {success: true, school_teachers: school_teachers}
  end

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    response = create_teachers(@school, create_school_teachers_params)
    render :json => response
  end

  def update
    render json: {success: false, errors: ['Teacher not found']} and return if @teacher.blank?
    response = update_school_teacher(@teacher, update_school_teacher_params)
    render :json => response
  end

  def destroy
    render json: {success: false, errors: ['Teacher not found']} and return if @teacher.blank?
    @teacher.destroy!
    render json: {success: true}
  end

  private

  def find_school
    @school = School.find_by(id: params[:school_id])
  end

  def find_teacher
    @teacher = Teacher.find_by(id: params[:id])
  end

  def create_teachers(school, datum)
      #TODO ADD CREATE CODE HERE
  end

  def create_school_teachers_params
    #TODO ADD MORE PARAMS
    params.require(:administrator).permit(:first_name, :last_name, :cell_number)
  end

  def update_school_teacher(teacher, datum)
      #TODO ADD UPDATE CODE HERE
  end

  def update_school_teacher_params
      #TODO ADD MORE PARAMS
      params.require(:administrator).permit(:first_name, :last_name, :cell_number)
  end


end
