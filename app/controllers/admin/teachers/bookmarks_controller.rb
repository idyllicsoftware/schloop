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
      bookmarks = Bookmark.index(current_teacher || Teacher.first, params[:topic_id])
      render json: {success:true, bookmarks: bookmarks}
    rescue Exception => e
      errors << "errors while fetching bookmarks"
      render json: {success:false, errors: errors}
    end  
  end

  private

  def bookmark_params
    teacher = current_teacher || Teacher.first
    data_type = get_data_type(params[:datum])
    bookmark_datum = {}
    (data_type == :url) ? (bookmark_datum[:url] = params[:datum]) : (bookmark_datum[:data] = params[:datum])
    bookmark_datum[:data_type] = Bookmark.data_types[data_type]
    bookmark_datum[:topic_id] = params[:topic_id]
    bookmark_datum[:subject_id] = params[:subject_id]
    bookmark_datum[:grade_id] = params[:grade_id]
    bookmark_datum[:teacher_id] = teacher.id
    bookmark_datum[:school_id] = teacher.school_id
    ### default title for temporary purpose
    bookmark_datum[:title] = "new schloopmark added"
    if data_type == :url 
      bookmark_datum[:preview_image_url] = get_preview_image_url(params[:datum])
    end
    return bookmark_datum
  end

  def get_data_type(input_data)
    begin 
      uri = URI(input_data)
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path
      if (response.code.start_with?('2') or response.code.start_with?('3')) 
        return :url
      end
    rescue Exception => e
        return :text
    end
    return :text
  end

  private
  def get_preview_image_url(url)
    require 'link_thumbnailer'
    preview_object = LinkThumbnailer.generate(url)
    preview_object.images.present? ? preview_image_url = preview_object.images.first.src : preview_image_url = "image not found"
    return preview_image_url
  end
end
