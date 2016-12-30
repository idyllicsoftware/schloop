class Admin::Teachers::CommentsController < ApplicationController
  
  def create
    errors = []
    begin
      comment_data = {
      commentable_id: params[:id],
      commentable_type:  params[:comment_type],
      message: params[:message],
      commented_by: current_teacher.id
      }
      comment = Comment.create(comment_data)
    rescue Exception => e
      errors <<  "errors while creating new comment"
    end
    # teacher_name = current_teacher.first_name + " " + current_teacher.last_name
    # comment_datum = {
    #  collaboration_id: comment.commentable_id,
    #  message: comment.message,
    #  teacher_id: comment.commented_by,
    #  teacher_name: teacher_name
    # }
  render json: {success:errors.blank?, errors: errors}
  end

end
