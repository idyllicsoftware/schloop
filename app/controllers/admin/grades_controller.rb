class Admin::GradesController < Admin::BaseController
  before_action :find_school, only: [:index, :create, :grades_divisions]
  before_action :find_grades, only: [:index, :create]
  before_action :load_grade, only: [:destroy]
  layout "admin"

  def index
    grade_data = []
    @grades = @grades.sort_by(& :created_at).reverse
    @grades.each do |grade|
      subjects = []
      grade.subjects.each do |subject|
        divisions = []
        grade.divisions.each do |division|
          teachers = []
          teacher_ids = GradeTeacher.where(grade_id: grade.id).where(subject_id: subject.id).where(division_id: division.id).pluck(:teacher_id)
          teacher_records = Teacher.where(id: teacher_ids)
          teacher_records.each do |teacher_record|
            teachers << { teacher_id: teacher_record.id, first_name: teacher_record.first_name, middle_name: teacher_record.middle_name, last_name: teacher_record.last_name, email: teacher_record.email, phone: teacher_record.cell_number}
          end
          divisions <<  {division_id: division.id, division_name: division.name, teacher: teachers}
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
    if params[:grades_data][:master_subject_ids].blank?
      render json: { success: false, errors: 'please select subjects.' } and return
    end
    response = Grade.create_grade(@school, params[:grades_data])
    render :json => response
  end

  def destroy
    response = @grade.destroy_grade
    render json: response
  end

  private

  def load_grade
    @grade = Grade.includes(:divisions, :subjects, :bookmarks).find_by(id: params[:id])
    render json: { success: false, errors: ['Grade not found'] } and return if @grade.blank?
  end

  def find_grades
    @grades = Grade.where(school_id: params[:school_id]).includes(:subjects, :divisions)
  end

  def find_school
    @school = School.find_by(id: params[:school_id])
    render json: { success: false, errors: ['School not found'] } and return if @school.blank?
  end

  def create_school_admin_params
    params.require(:administrator).permit(:first_name, :last_name, :cell_number, :email)
  end

end
