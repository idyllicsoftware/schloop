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
end

.