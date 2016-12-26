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
      render json: {success:true, bookmarks: bookmarks}
    rescue Exception => e
      errors << "errors while fetching bookmarks"
      render json: {success:false, errors: errors}
    end  
  end

  def add_caption
    errors = []
    begin
      bookmark = Bookmark.find_by(id: params[:bookmark_id])
      bookmark.caption = params[:caption]
      bookmark.save
    rescue Exception => e
      errors << "error occured while adding caption"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  private

  def bookmark_params
    teacher = current_teacher
    data_type = get_data_type(params[:datum])
    bookmark_datum = {}
    (data_type == :url) ? (bookmark_datum[:url] = params[:datum]) : (bookmark_datum[:data] = params[:datum])
    bookmark_datum[:data_type] = Bookmark.data_types[data_type]
    bookmark_datum[:topic_id] = params[:topic_id]
    bookmark_datum[:subject_id] = params[:subject_id]
    bookmark_datum[:grade_id] = params[:grade_id]
    bookmark_datum[:teacher_id] = teacher.id
    bookmark_datum[:school_id] = teacher.school_id
    if data_type == :url 
      preview_image_data = get_preview_image_url(params[:datum])
      preview_image_data[:title].present? ? (bookmark_datum[:title] = preview_image_data[:title]) : (bookmark_datum[:title] = "Schloopmark Web URL")
      bookmark_datum[:preview_image_url] = preview_image_data[:preview_image_url]
      #bookmark[:preview_image_url] = get_preview_image_url(params[:datum])
    else
      bookmark_datum[:title] = "Schloopmark Note"
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
    title = preview_object.title
    if preview_object.images.present?  
      preview_image_url = preview_object.images.first.src  
    elsif preview_object.url.present?
      preview_image_url = preview_object.url.to_s
    else
      preview_image_url = "image not found"
    end
    return { title: title, preview_image_url: preview_image_url }
  end
end
