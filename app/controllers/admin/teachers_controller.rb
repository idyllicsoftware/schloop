=begin
[
  {
    grade_id: '1',
    grade_name: 'grade_one',
    subjects_data: [
      {
        subject_id: '1',
        subject_name: 'maths',
        divisions_data: [
          {division_id: '1', division_name: 'A', check:status: true},
          {division_id: '2', division_name: 'B', check:status: false},
        ]
      },
      {
        subject_id: '2',
        subject_name: 'Sci',
        divisions_data: [
          {division_id: '1', division_name: 'A', check:status: true},
          {division_id: '2', division_name: 'B', check:status: true},
        ]
      }
    ]
  },
  {
    grade_id: '2',
    grade_name: 'grade_two',
    subjects_data: [
      {
        subject_id: '1',
        subject_name: 'maths',
        divisions_data: [
          {division_id: '1', division_name: 'A', check:status: false},
          {division_id: '2', division_name: 'B', check:status: false},
        ]
      },
      {
        subject_id: '2',
        subject_name: 'Sci',
        divisions_data: [
          {division_id: '1', division_name: 'A', check:status: false},
          {division_id: '2', division_name: 'B', check:status: true},
        ]
      }
    ]
  }
]

=end
class Admin::TeachersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create]
  before_action :find_teacher, only: [:update, :destroy]
  layout "admin"


  def index
    school_teachers = []
    @school_teachers =@school.teachers.order(:id)
    #@school_teachers.order(:created_at)

   # @school_teachers.sort_by { |m| [ m.updated_at,m.created_at].max}.reverse!
    @school_teachers.each do |teacher|
      grade_teacher_data = get_grade_teacher_data(teacher.id)
      school_teachers << {
        id: teacher.id,
        first_name: teacher.first_name,
        last_name: teacher.last_name,
        image_url: 'https://dummyimage.com/45x45/2abdda/0011ff&text=1',
        cell_number: teacher.cell_number,
        email: teacher.email,
        grade_teacher_data: grade_teacher_data
      }
    end
    render json: {success: true, school_teachers: school_teachers}
  end

  def create
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    create_teachers_response = create_teachers(@school, create_school_teachers_params)
    if create_teachers_response[:success] and params[:grade].present?
      create_teachers_response = create_grade_teacher_association(create_teachers_response[:teacher_id])
    end
    render json: create_teachers_response
  end

  def update
    render json: {success: false, errors: ['Teacher not found']} and return if @teacher.blank?
    errors = []
    ActiveRecord::Base.transaction do
      begin
        if params[:grade].present?
          @teacher.grade_teachers.destroy_all
          create_grade_teacher_association(@teacher.id)
        end
        update_response = update_school_teacher(@teacher, update_school_teacher_params)
        errors = update_response[:errors]
      rescue Exception => ex
        errors << 'Error occured while updating teacher.'
        raise ActiveRecord::Rollback
      end
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def destroy
    render json: {success: false, errors: ['Teacher not found']} and return if @teacher.blank?
    @teacher.destroy!
    render json: {success: true}
  end

  def forget_password 
  end

  private

  def find_school
    @school = School.find_by(id: params[:school_id])
  end

  def find_teacher
    @teacher = Teacher.find_by(id: params[:id])
    if @teacher.blank?
      {success: false, errors: ["teacher not found"]}
    end
  end

  def create_teachers(school, teacher_params)
    teacher_params.merge!(password: Devise.friendly_token.gsub('-','').first(6))
    teacher = school.teachers.create(teacher_params)
    errors =  teacher.errors.full_messages.join(', ')

    return {success: true, teacher_id: teacher.id} if errors.blank?
    return {success: false, errors: errors}
  end

  def create_school_teachers_params
    params.require(:teacher).permit(:first_name, :last_name, :cell_number, :email)
  end

  def update_school_teacher(teacher,teacher_params)
    errors = []
    teacher.update(teacher_params)
    if teacher.errors.blank?
      return { success: true, error: errors }
    else
      errors << teacher.errors.full_messages
      return {success: false, errors: errors}
    end
  end

  def update_school_teacher_params
      params.require(:teacher).permit(:first_name, :last_name, :cell_number)
  end

=begin
  def grade_teacher_params
    response = {
              school_id: params[:school_id],
              grade_id: params[:grade_id],
              subjects: params[:subjects],
              divisions: params[:divisions]
    }
    return response
  end
=end
  def get_grade_teacher_data(teacher_id)
    grade_teacher_data = []
    teacher = Teacher.find(teacher_id)
    grades_data = teacher.grade_teachers.group_by do |x| x.grade_id end

    grades_data.each do |grade_id, datas|
      subjects_data = {}
      datas.each do |data|
        subjects_data[data.subject_id ] ||= {
          subject_id: data.subject_id,
          subject_name: data.subject.name,
          divisions_data: []
        }
        
        subjects_data[data.subject_id][:divisions_data] << {
          division_id: data.division_id,
          division_name: data.division.name        
        }
      end
      grade_teacher_data << {
        grade_id: grade_id,
        grade_name: datas.first.grade.name,
        subjects_data: subjects_data.values
      }
    end
    return grade_teacher_data
  end

  def create_grade_teacher_association(teacher_id)
    errors, create_grade_teacher_params = [], []
    begin
      grades = params[:grade] || {}
      grades.each do |grade_id, grades_data|
        grades_data[:subjects].each do |subject_id, divisions_data|
          divisions_data[:divisions].each do |division_id|
            create_grade_teacher_params << {
              teacher_id: teacher_id,
              grade_id: grade_id,
              subject_id: subject_id,
              division_id: division_id
            }
          end
        end
      end
      GradeTeacher.create(create_grade_teacher_params)
    rescue Exception => ex
      errors << "error occured while creating grade teacher asssociation. \n #{ex.message}"
      return {success: false, errors: errors}
    end
    return {success: true, data: {}}
  end

end
