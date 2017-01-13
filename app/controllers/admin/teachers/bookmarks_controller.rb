class Admin::Teachers::BookmarksController < ApplicationController

  def create
    errors = []
    begin
      Bookmark.create!(bookmark_params)
    rescue Exception => e
      errors << "error occured while inserting new bookmark" + "," + e.message
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def get_bookmarks
    bookmark_data = []
    bookmarks = Bookmark.where(grade_id: params[:grade_id], subject_id: params[:subject_id], topic_id: params[:topic_id])
                  .includes(:topic, :teacher).order(id: :desc)              
    bookmark_ids = bookmarks.ids              
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    bookmarks.each do |bookmark|
      filtered_bookmark_data = bookmark.formatted_data
      filtered_bookmark_data.merge!(is_collaborated: collaborated_bookmark_ids.include?(bookmark.id))
      filtered_bookmark_data.merge!(is_followedup: followed_bookmark_ids.include?(bookmark.id))
      bookmark_data << filtered_bookmark_data
    end
    render json: {success: true, error: nil, bookmark_data: bookmark_data}
  end

  def add_caption
    errors = []
    begin
      bookmark = Bookmark.find_by(id: caption_params[:bookmark_id])
      bookmark.update!(caption: caption_params[:caption])
    rescue Exception => e
      errors << "error occured while adding caption" + "," + e.message
      render json: { success: errors.blank?, errors: errors } and return
    end
    render json: { success: errors.blank?, caption:bookmark.caption }
  end

  def destroy
    errors = []
    begin
      bookmark = Bookmark.find_by(id: delete_params[:id])  
      bookmark.destroy
    rescue Exception => e
      errors << "unable to destroy bookmarks" + ','+ e.message
    end
    render json: {success: errors.blank?, errors: errors}
  end

  def bookmark_like_or_view
    errors = []
    tracker_params = like_or_view_params
    event = tracker_params[:event]
    user = current_teacher || current_user
    bookmark = Bookmark.find_by(id: tracker_params[:bookmark_id])
    errors << "Invalid bookmark to track" if bookmark.blank?
    if errors.blank?
      like_state = params[:like_state]
      bookmark.track_bookmark(event, like_state, user)
    end
    render json:{ success: errors.blank?, errors: errors, bookmark: bookmark.reload}
  end

  private

  def bookmark_params
    bookmark_datum = {}
    bookmark_datum.merge!(permited_bookmark_params)
    bookmark_datum.merge!(generate_bookmark_params(bookmark_datum))
    return bookmark_datum
  end

  def permited_bookmark_params
    params.permit(:data, :topic_id, :subject_id, :grade_id).deep_symbolize_keys
  end

  def generate_bookmark_params(bookmark_data)
    datum = {}
    teacher = current_teacher
    is_url = Util::NetworkUtils.valid_url?(bookmark_data[:data])
    data_type = is_url ? :url : :text
    datum[:data_type] = Bookmark.data_types[data_type]
    datum[:teacher_id] = teacher.id
    datum[:school_id] = teacher.school_id
    return datum.deep_symbolize_keys
  end

  def delete_params
    params.permit(:id)
  end

  def like_or_view_params
    params.permit(:event, :bookmark_id, :like_state)
  end

  def caption_params
    params.permit(:bookmark_id,:caption)
  end


end
