class Admin::Teachers::CommentsController < ApplicationController
  
  def create
    errors = []
    begin
      comment_data {
      commentable_id: params[:id],
      commentable_type:  params[:comment_type],
      message: params[:message],
      commeted_by: current_teacher
      }
      comment = Comment.create(comment_data)
    rescue Exception => e
      errors <<  "errors while creating new comment"
    end
  end

end
