class Admin::Teachers::DashboardsController < ApplicationController

	layout "teacher"
	
  def create
     errors = []
    begin
      teacher = Teacher.find_by(id: params[:id])
      bookmark_data = {
        title: params[:title],
        subject_id: params[:subject_id],
        grade_id:  params[:grade_id],
        topic_id:  params[:topic_id],
        data:  params[:data],
        data_type: params[:data_type],
        caption:  params[:caption],
        teacher_id:  Teacher.find_by(id: params[:id]).id,
        school_id:  School.find_by(id: teacher.school_id).id
       }
       Bookmark.create(bookmark_data)
    rescue Exception => e
      errors << "error while creating new bookmark"
    end
    render json: {success: errors.blank?, errors: errors}
  end
 

   def show
  binding.pry
  #@grades = GradeTeacher.select("distict grade_id,subject_id").where(teacher_id: params[:id]) 
  teacher_id= params[:id]

  grade_teacher_data = []
  topic_data= []
  teacher = Teacher.find(teacher_id)
  grades_data = teacher.grade_teachers.group_by do |x| x.grade_id end

   grades_data.each do |grade_id, datas|
    subjects_data = {}

     datas.each do |data|
       subjects_data[data.subject_id ] ||= {
         subject_id: data.subject_id,
         subject_name: data.subject.name,
         topic_data: []
       }

       subjects_data[data.subject_id][:topic_data] << {
         topic_id: data.topic_id,
         topic_name: data.topic.name
       } 

       subjects_data[data.subject_id][:divisions_data] << {
         division_id: data.division_id,
         division_name: data.division.name
       }
               

     grade_teacher_data << {
       grade_id: grade_id,
       grade_name: datas.first.grade.name,
       subjects_data: subjects_data.values
     }

   end
end
   return grade_teacher_data
 end 
end



