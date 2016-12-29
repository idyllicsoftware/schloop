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
        comments = collaboration.comments
        collaboration_data << { collaboration_id: collaboration.id, collaboration_data: collaboration, bookmark_id: bookmark.id, bookmark_data: bookmark_data(collaboration.bookmark), comments: comments }
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

  private
  def bookmark_data(bookmark)
    datum = { bookmark_id: bookmark.id,
               title: bookmark.title,
               data: bookmark.data,
               data_type: bookmark.data_type,
               caption: bookmark.caption,
               url: bookmark.url,
               preview_image_url: bookmark.preview_image_url,
               likes: bookmark.likes,
               views: bookmark.views,
               topic_name: bookmark.topic.title,
               grade_name: bookmark.grade.name,
               subject_name: bookmark.subject.name
            }
    return datum
  end

end
