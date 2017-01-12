class Admin::Teachers::CommentsController < ApplicationController
  
  def create
    errors = []
    begin
      bookmark = Bookmark.find_by(id: comment_params[:id])
      collaboration = bookmark.collaboration
      comment_data = {
      commentable_id: collaboration.id,
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
    params.permit(:id, :comment_type, :message)
  end

end
