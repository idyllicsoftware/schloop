class Admin::Teachers::TopicsController < ApplicationController
	layout "teacher"

  def show
    topic=Topic.where(master_grade_id: params[:master_grade_id],master_subject_id:params[:master_subject_id],is_created_by_teacher:params[:is_created_by_teacher])
    topic_data ={}
    topic.each do|data|
      {
          master_grade_id: data.master_grade_id,
          master_subject_id: data.master_subject_id,

      }
      render json: {success: false, errors: ['topic not found']} and return if @topic.blank?
      return topic_data
    end
  end

  def create
    errors = []
    begin  
      Topic.create(topic_params)
    rescue Exception => e
      errors << "error occured while inserting new topic"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def get_topics
    errors = []
    begin
      grade  = Grade.find_by(id: params[:grade_id])
      subject = Subject.find_by(id: params[:subject_id])
      master_grade_id = grade.master_grade_id
      master_subject_id = subject.master_subject_id
      topics = Topic.index(current_teacher, master_grade_id, master_subject_id)
      render json: {success:true, topics: topics}
    rescue Exception => e
      errors << "errors while fetching topics"
      render json: {success:false, errors: errors}
    end  
  end

  private

  def topic_params
    topic_datum = {}
    topic_datum[:title] = params[:title]
    topic_datum[:master_grade_id] = Grade.find_by(id: params[:grade_id]).master_grade_id
    topic_datum[:master_subject_id] = Subject.find_by(id: params[:subject_id]).master_subject_id
    topic_datum[:teacher_id] = current_teacher.id
    return topic_datum
  end

end
