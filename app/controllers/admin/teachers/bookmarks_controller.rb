class Admin::Teachers::BookmarksController < ApplicationController

  def create
    errors = []
    begin
      Bookmark.create!(bookmark_params)
    rescue Exception => e
      errors << "error occured while inserting new bookmark"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def get_bookmarks
    errors = []
    begin
      bookmarks = Bookmark.index(current_teacher, params[:topic_id])
      collaborated = Collaboration.where(bookmark_id: bookmarks.ids).pluck('distinct bookmark_id')
      render json: { success:true, bookmarks: bookmarks, collaborated: collaborated }
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
      render json: { success: errors.blank?, errors: errors } and return
    end
    render json: { success: errors.blank?, caption:bookmark.caption }
  end

  def destroy
    errors = []
    begin
      bookmark = Bookmark.find_by(id:params[:id])
      bookmark.destroy
    rescue Exception => e
      errors << "unable to destroy bookmarks"
    end
    render json: {success: errors.blank?, errors: errors}
  end

  def update
    errors = []
    begin
      bookmark = Bookmark.find_by(id: params[:bookmark_id])
      bookmark.update!(generate_update_params)
    rescue Exception => e
      errors << "error occured while inserting new bookmark"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def bookmark_like_or_view
    errors = []
    tracker_params = like_or_view_params
    event = tracker_params[:event]
    user = current_teacher || current_user
    bookmark = Bookmark.find_by(id: tracker_params[:bookmark_id])

    errors << "Invalid bookmark to track" if bookmark.blank?
    if errors.blank?
      like_state = params[:like_state] || "true"
      bookmark.track_bookmark(event, like_state, user)
    end
    render json:{ success: errors.blank?, errors: errors, bookmark: bookmark}
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

  def generate_update_params
    bookmark_datum = {}
    bookmark_datum[:caption] = params[:bookmark][:caption]
    is_url = Util::NetworkUtils.valid_url?(params[:data])
    data_type = is_url ? :url : :text
    bookmark_datum[:data_type] = Bookmark.data_types[data_type]
    bookmark_datum[:data] = params[:data]
    return bookmark_datum
  end

  def update_params
    params.permit(:data, :bookmark)
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

  def like_or_view_params
    params.permit(:event, :bookmark_id, :like_state)
  end

end
