class Admin::TopicsController < ApplicationController

  def index
    teacher = current_teacher
    grade_id = Teacher.last.grade_teachers.minimum(:grade_id)
    subject_id = Teacher.last.grade_teachers.minimum(:subject_id)
    topics = Topic.where(grade_id: grade_id, teacher_id: teacher.id, subject_id: subject_id)
    grade_teachers_data_service = GradeTeachersDataService.new
    grade_teachers_data = grade_teachers_data_service.get_grade_teacher_data(teacher.id) 

    if topics.blank?
      render json: { msg: "no record found" }
    else
      render json: {topics: topics, grade_teachers_data: grade_teachers_data}
    end
  end

  def show
    teacher = current_teacher
    school = teacher.school
    grade_teachers_data_service = GradeTeachersDataService.new
    grade_teachers_data = grade_teachers_data_service.get_grade_teacher_data(teacher.id) 
    render json: { success: true, data: grade_teachers_data }
  end

  def get_topics(teacher_id,grade_id,subject_id)
  end 
end
