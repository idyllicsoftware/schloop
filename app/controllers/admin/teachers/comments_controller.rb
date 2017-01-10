class Admin::Teachers::CommentsController < ApplicationController
  
  def create
    errors = []
    begin
      comment_data = {
      commentable_id: comment_params[:id],
      commentable_type:  comment_params[:comment_type],
      message: comment_params[:message],
      commented_by: current_teacher.id,
      commenter: current_teacher.name
      }
      comment = Comment.create(comment_data)
    rescue Exception => e
      errors <<  "errors while creating new comment"
    end
  render json: {success:errors.blank?, errors: errors}
  end

  private
  def comment_params
    params.permit(:id, :commment_type, :message)
  end

end
