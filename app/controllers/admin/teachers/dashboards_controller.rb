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
end