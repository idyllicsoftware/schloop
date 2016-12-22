class Admin::Teachers::BookmarksController < ApplicationController

  def create
    errors = []
    begin  
      Bookmark.create(bookmark_params)  
    rescue Exception => e
      errors << "error occured while inserting new bookmark"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def get_bookmarks
    errors = []
    begin
      bookmarks = Bookmark.index(current_teacher, params[:topic_id])
      render json: {success:true, topics: bookmarks}
    rescue Exception => e
      errors << "errors while fetching bookmarks"
      render json: {success:false, errors: errors}
    end  
  end

  private

  def bookmark_params
    teacher = Teacher.first
    bookmark_datum = {}
    bookmark_datum[:title] = params[:title]
    bookmark_datum[:data] = params[:data]
    bookmark_datum[:caption] = params[:caption]
    bookmark_datum[:url] = params[:url]
    bookmark_datum[:preview_image_url] = params[:preview_image_url]
    bookmark_datum[:topic_id] = params[:topic_id]
    bookmark_datum[:data_type] = params[:data].blank? ? 1 : 0 
    bookmark_datum[:teacher_id] = teacher.id
    bookmark_datum[:subject_id] = params[:subject_id]
    bookmark_datum[:grade_id] = params[:grade_id]
    bookmark_datum[:school_id] = teacher.school_id
    return bookmark_datum
  end

end
