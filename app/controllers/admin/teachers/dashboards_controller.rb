class Admin::Teachers::DashboardsController < ApplicationController

	layout "teacher"
	
  def create 
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
 grade_teacher_data = []
    @teacher = Teacher.find_by(id: params[:id])
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

end



