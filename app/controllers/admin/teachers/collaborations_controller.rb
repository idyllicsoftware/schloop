class Admin::Teachers::CollaborationsController < ApplicationController

  def index 
    collaboration_data = []
    teacher= current_teacher || Teacher.first
    grade_ids = teacher.grade_teachers.pluck(:grade_id).uniq
    subject_ids = teacher.grade_teachers.pluck(:subject_id).uniq  
    bookmarks = Bookmark.where(grade_id: grade_ids).where(subject_id: subject_ids)
    collaborations = Collaboration.pluck(:bookmark_id)
    bookmarks.each do |bookmark|
      if collaborations.include?(bookmark.id)
        collaboration = Collaboration.find_by(bookmark_id: bookmark.id)
        collaboration_data << {collaboration_message: collaboration.collaboration_message, bookmark: collaboration.bookmark}
      end
    end
    render json: {success: true, data: collaboration_data}
  end 
 
  def create
    errors = []
    begin 
      new_collaboration = Collaboration.create(bookmark_id: params[:bookmark_id], collaboration_message: params[:collaboration_message])
    rescue Exception => e
      errors << "error while collaborating schloopmark"
    end
    render json: {success: errors.blank?, errors: errors}
  end

end