class Admin::Teachers::CollaborationsController < ApplicationController

  def index 
    teacher= current_teacher
    grade_ids = teacher.grade_teachers.pluck(:grade_id).uniq
    subject_ids = teacher.grade_teachers.pluck(:subject_id).uniq  
    collaborations_bookmark_ids = Collaboration.pluck(:bookmark_id)
    bookmarks_ids = Bookmark.where(grade_id: grade_ids).where(subject_id: subject_ids).pluck(:id)
    filtered_bookmark_ids = collaborations_bookmark_ids & bookmarks_ids
    bookmark_datum = {}
    collaborations = Collaboration.where(bookmark_id: filtered_bookmark_ids).includes(:bookmark).includes(:comments)
    collaboration_datum = []
    collaborations.each do |collaboration|
      comments = collaboration.comments.order('created_at asc') 
      bookmark_datum = {bookmark: bookmark_data(collaboration.bookmark), comments: comments}
      collaboration_datum << {collaboration_id: collaboration.id, collaboration_data: bookmark_datum}
    end
    render json: {success: true, data: collaboration_datum}
  end 
 
  def create
    errors = []
    data = {}
    begin 
      bookmark = Bookmark.find_by(id: collaboration_params[:bookmark_id])
      errors << "bookmark not found" if bookmark.nil?
      #teachers = GradeTeacher.select('distinct teacher_id').where(grade_id: bookmark.grade_id).where(subject_id: bookmark.subject_id).collect(&:teacher_id)
      teacher_ids = GradeTeacher.select('distinct teacher_id').where(grade_id: bookmark.grade_id).where(subject_id: bookmark.subject_id).pluck(:teacher_id)
      first_teacher = Teacher.find_by(id: teacher_ids.first)
      new_collaboration = Collaboration.create(bookmark_id: collaboration_params[:bookmark_id])
      data = { teacher_name: first_teacher.name, count: teacher_ids.count }
    rescue Exception => e
      errors << "error while collaborating schloopmark"
    end
    render json: {success: errors.blank?, errors: errors, data: data}
  end

  def add_to_my_topics
    errors = []
    bookmark = bookmark_params
    teacher = current_teacher
    if Bookmark.find_by(id: bookmark_params[:bookmark_id], teacher_id: teacher.id).present?
          errors << "bookmark already present in my topics"
          render json: { success: errors.blank?, errors: errors } and return
    end
    ActiveRecord::Base.transaction do
      begin
        master_subject = Subject.find_by(id: bookmark[:subject_id]).master_subject
        master_grade = Grade.find_by(id: bookmark[:grade_id]).master_grade
        topic = Topic.find_by(teacher_id: teacher.id, master_grade_id: master_grade.id, master_subject_id: master_subject.id, title: bookmark[:topic_name])
        if topic.blank?       
          topic = Topic.create(title: bookmark[:topic_name], teacher_id: teacher.id, master_subject_id: master_subject.id, master_grade_id: master_grade.id)
        end
        data = {}
        data = bookmark.except(:topic_name,:topic_id, :bookmark_id)
        data[:teacher_id]=teacher.id 
        data[:topic_id]= topic.id
        new_bookmark = Bookmark.create!(data) 
      rescue Exception => ex
        errors << 'Errors occured while adding bookmark to my topics'
        raise ActiveRecord::Rollback
      end
    end
    render json: { success: errors.blank?, errors: errors }    
  end

  private
  def bookmark_data(bookmark)
    teacher = current_teacher
    is_liked = SocialTracker.find_by(sc_trackable: bookmark, user_type: teacher.class.to_s, user_id: teacher.id, event: 1).present?
    datum = { bookmark_id: bookmark.id,
              title: bookmark.title,
              data: bookmark.data,
              data_type: bookmark.data_type,
              caption: bookmark.caption,
              url: bookmark.url,
              preview_image_url: bookmark.preview_image_url,
              likes: bookmark.likes,
              views: bookmark.views,
              topic_id: bookmark.topic_id,
              topic_name: bookmark.topic.title,
              grade_id: bookmark.grade_id,
              grade_name: bookmark.grade.name,
              subject_id: bookmark.subject_id,
              subject_name: bookmark.subject.name
            }
    return datum
  end

  def bookmark_params
    params.require(:bookmark).permit(:bookmark_id, :title, :data, :data_type, :caption, :url, :preview_image_url, :topic_id, :topic_name, :grade_id, :subject_id)
  end

  def collaboration_params
    params.permit(:bookmark_id)
  end
end
