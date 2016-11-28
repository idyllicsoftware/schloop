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
    teacher_id = create_teachers(@school, create_school_teachers_params)
    response = create_grade_teacher_association(teacher_id)
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

  def create_teachers(school, teacher_params)
    teacher_params.merge!(password: Devise.friendly_token.gsub('-','').first(6))
    teacher = school.teachers.create(teacher_params)
    errors =  teacher.errors.full_messages.join(', ')

    if errors.blank?
      Admin::AdminMailer.welcome_message(teacher.email, teacher.first_name, teacher.password).deliver_now
      return {success: errors.blank?, teacher_id: teacher.id}
    else
        return {success: errors.blank?, errors: errors}
    end
  end

  def create_school_teachers_params
    params.require(:teacher).permit(:first_name, :last_name, :cell_number, :email)
  end

  def update_school_teacher(teacher,teacher_params)
     # respond_to do |format|
     teacher.update(teacher_params)
     return {success: true, error: []}
    #end
  end

  def update_school_teacher_params
      #TODO ADD MORE PARAMS
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

  def create_grade_teacher_association(teacher)
    errors = []
    grade_teacher = nil
    begin
      teacher_id = teacher[:teacher_id]
      grades = params[:grade]
      grades.each do |grade|
        grade_id = grade[0].to_i
        grade_data = grade[1]
        subjects = grade_data[:subjects]
        subjects.each do |subject|
          subject_id = subject[0].to_i
          subject_data = subject[1]
          divisions= subject_data[:divisions]
          divisions.each do |division|
            grade_teacher = GradeTeacher.create(teacher_id: teacher_id,grade_id: grade_id, subject_id: subject_id, division_id: division.to_i)
          end
        end
      end
    rescue Exception => e
      errors << "error occured while creating grade teacher asssociation"
      return {success: false, errors: errors}
    end
    return {success: true, grade_teacher: grade_teacher}

  end
end
