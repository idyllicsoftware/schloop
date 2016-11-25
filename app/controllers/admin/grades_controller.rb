=begin 
grades = []
@grades.each do |grade|
  subjects = []
  grade.subjects.each |subject| do 
    divisions = []
    grade.divisions.each |division| do
      teacher = []
      teacher_id = GradeTeacher.where(grade_id: grade.id, subject_id: subject.id, division_data: division.id).select('teacher_id')
      teacher_data = Teacher.where(id: teacher_id)
      teacher << {teacher_id: teacher_id, first_name: teacher_data.first_name, middle_name: teacher_data.middle_name, last_name: teacher_data.last_name, email: teacher_data.email, phone: teacher_data.cell_number }
      division_data << {division_id: division.id, division_name: division.name, teacher: teacher}
      divisions <<division_data
    end
    subject_data << { subject_id: subject.id, subject_name: subject.name, divisions: divisions}
    subjects << subject_data
  end
  grade_data << { grade_id: grade.id, grade_name: grade.name, subjects:subjects }
end
=end
=begin
grade_data {
  grades: [
    {
      grade_id: 1,
      grade_name: 'grade1',
      subjects: {
        subject_id: 1,
        subject_name: 'math',
        divisions:{
          division_id: 2,
          division_name: 'A',
          teacher:{
            teacher_id: 1
            teacher_name: 'Axle Blaze'
            teacher_email: 'axleblaze@idyllic.co'
            teacher_phone: '8786565434'
          }
        }
      }
    }
  ]
}
=end

class Admin::GradesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_school, only: [:index, :create, :grades_divisions]
  before_action :find_grades, only: [:index, :create]
  layout "admin"

  def index
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    grade_data = []
    @grades.each do |grade|
      subjects = []
      grade.subjects.each do |subject| 
        divisions = []
        grade.divisions.each do |division|
          teacher = []
          grade_teacher = GradeTeacher.where(grade_id: grade.id).where(subject_id: subject.id).where(division_id: division.id).pluck(:teacher_id)
          teacher_id =grade_teacher.first
          if teacher_id.present?
            teacher_data = Teacher.find(teacher_id)
            teacher << { teacher_id: teacher_id, first_name: teacher_data.first_name, middle_name: teacher_data.middle_name, last_name: teacher_data.last_name, email: teacher_data.email, phone: teacher_data.cell_number}
          end
          divisions <<  {division_id: division.id, division_name: division.name, teacher: teacher}
        end
        subjects << { subject_id: subject.id, subject_name: subject.name, divisions: divisions}
      end
      grade_data << { grade_id: grade.id, grade_name: grade.name, subjects:subjects }
    end
    render json: {success: true, grades: grade_data}
  end

  def grades_divisions
    render json: {success: false, errors: ['School not found']} and return if @school.blank?
    @grades = Grade.where(school_id: params[:school_id]).includes(:divisions)
    grade_data = []
    @grades.each do |grade|
      divisions = []
      grade.divisions.each do |division|
        divisions <<  {division_id: division.id, division_name: division.name}
      end
      grade_data << { grade_id: grade.id, grade_name: grade.name, divisions: divisions }
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
