class Admin::TopicsController < ApplicationController

  def index
    teacher = current_teacher
    school = teacher.school
    grade_teachers_data_service = GradeTeachersDataService.new
    grade_teachers_data = grade_teachers_data_service.get_grade_teacher_data(teacher.id) 
    render json: { success: true, data: grade_teachers_data }
  end
end
