class Admin::TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create]
  before_action :find_teacher, only: [:update, :destroy]
  layout "admin"


  def index
    school_teachers = [{
         id: 1,
         first_name: 'Ruchi',
         last_name: 'P.',
         image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=1',
         cell_number: '1234567890',
         email: 'admim@schloop.co',
    }, {
        id: 2,
        first_name: 'Ruchi 1',
        last_name: 'P.',
        image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=2',
        cell_number: '1234567890',
        email: 'admim@schloop.co',
    }, {
         id: 3,
         first_name: 'Ruchi 2',
         last_name: 'P.',
         image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=3',
         cell_number: '1234567890',
         email: 'admim@schloop.co',
     }, {
         id: 4,
         first_name: 'Ruchi 1',
         last_name: 'P.',
         image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=4',
         cell_number: '1234567890',
         email: 'admim@schloop.co',
     }, {
         id: 5,
         first_name: 'Ruchi 2',
         last_name: 'P.',
         image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=5',
         cell_number: '1234567890',
         email: 'admim@schloop.co',
     }]
    # render json: {success: false, errors: ['School not found']} and return if @school.blank?
    # school_teachers = @school.teachers.select(:id, :first_name, :last_name, :cell_number, :email).order('created_at').all
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
    return {success: true}
      #TODO ADD CREATE CODE HERE
  end

  def create_school_teachers_params
    #TODO ADD MORE PARAMS
    params.require(:teacher).permit(:first_name, :last_name, :cell_number)
  end

  def update_school_teacher(teacher, datum)
      #TODO ADD UPDATE CODE HERE
  end

  def update_school_teacher_params
      #TODO ADD MORE PARAMS
      params.require(:teacher).permit(:first_name, :last_name, :cell_number)
  end


end
