class Admin::Teachers::DashboardsController < ApplicationController
  
  def index
    topics =get_topics
  end
  def show
    topics = get_topics
    render json: {topics: topics}
  end
  def create
    bookmark_datum = {}
    errors = []
    teacher = Teacher.find_by(id: params[:teacher_id])
    begin
      bookmark_data = {
        title: params[:title],
        data:  params[:data],
        caption:  params[:caption],
        url: params[:url],
        preview_image_url: params[:preview_image_url],
        topic_id:  params[:topic_id],
        data_type: params[:data_type],
        school_id:  School.find_by(id: teacher.school_id).id,
        grade_id:  params[:grade_id],
        subject_id: params[:subject_id],
        teacher_id:  teacher.id
      }
      Bookmark.create(bookmark_datum)
    rescue Exception => e
      errors << "error occured while creating new bookmark"
    end
    render json: {success: !errors.present?, errors: errors}
  end

  def get_topics
    teacher = current_teacher
    grade  = Grade.find_by(id: params[:grade_id])
    subject = Subject.find_by(id: params[:subject_id])
    master_grade_id = grade.master_grade_id
    master_subject_id = subject.master_subject_id

    topics = Topic.index(teacher, master_grade_id, master_subject_id)
    render json: {success: true, topics: topics}
  end

  def get_bookmarks
    topic_id = params[:topic_id]
    teacher = current_teacher
    bookmarks = Bookmark.where(topic_id: topic, teacher_id: teacher.id)
  end
end
