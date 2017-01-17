class Admin::Teachers::TopicsController < Admin::Teachers::BaseController
	layout "teacher"

  def create
    errors = []
    begin  
      Topic.create!(generate_topic_params)
    rescue Exception => e
      errors << "error occured while inserting new topic" + "," +e.message
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def get_topics
    errors = []
    begin
      grade  = Grade.find_by(id: topic_params[:grade_id])
      subject = Subject.find_by(id: topic_params[:subject_id])
      master_grade_id = grade.master_grade_id
      master_subject_id = subject.master_subject_id
      topics = Topic.index(current_teacher, master_grade_id, master_subject_id)
      render json: {success:true, topics: topics}
    rescue Exception => e
      errors << "errors while fetching topics" + "," + e.message
      render json: {success:false, errors: errors}
    end  
  end

  private

  def topic_params
    params.permit(:grade_id,:subject_id,:title)
  end
  
  def generate_topic_params
    topic_datum = {}
    topic_datum[:title] = topic_params[:title]
    topic_datum[:master_grade_id] = Grade.find_by(id: topic_params[:grade_id]).master_grade_id
    topic_datum[:master_subject_id] = Subject.find_by(id: topic_params[:subject_id]).master_subject_id
    topic_datum[:teacher_id] = current_teacher.id
    return topic_datum
  end

end
