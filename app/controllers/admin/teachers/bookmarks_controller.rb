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
    errors = []
    begin
      bookmarks = Bookmark.index(current_teacher, params[:topic_id])
      collaborated = Collaboration.where(bookmark_id: bookmarks.ids).pluck('distinct bookmark_id')
      render json: { success:true, bookmarks: bookmarks, collaborated: collaborated }
    rescue Exception => e
      errors << "errors while fetching bookmarks" + "," + e.message
      render json: {success:false, errors: errors}
    end  
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
     render json: { success: errors.blank?, caption: bookmark.caption }
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

  def update
    errors = []
    begin  
      ####remove this params[:bookmark_id] with strict params
      bookmark = Bookmark.find_by(id: params[:bookmark_id])
      bookmark.update!(generate_update_params)  
    rescue Exception => e
      errors << "error occured while inserting new bookmark" +','+ e.message
      errors <<  bookmark.errors.full_messages.join(',')
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def bookmark_like_or_view
    tracker_params = like_or_view_params
    event = tracker_params[:event]
    errors = []
    user = current_teacher ? current_teacher : current_user
    bookmark = Bookmark.find_by(id: tracker_params[:bookmark_id])
    errors << "Invalid bookmark to track" if bookmark.blank?
    begin
      if errors.blank?
        if (event.eql? 'like') and (tracker_params[:like_state].eql? "false")
          record = SocialTracker.find_by(user_type: user.class.to_s, user_id: user.id, sc_trackable_type: bookmark.class.to_s, sc_trackable_id: bookmark.id, event: SocialTracker.events[event.to_sym])
          record.destroy
          bookmark.decrement!(:likes) unless record.errors.present?
        else
          response = SocialTracker.track(bookmark, user, event, user.class.to_s)
          SocialTracker.events[event.to_sym] == 1 ? bookmark.increment!(:likes) : bookmark.increment!(:views) unless response.include? "Sc trackable has already been taken"
        end
      end
    rescue 
      Exception => e
      errors << "errors occured while manipulating like and view"
    end
    render json:{ success: errors.blank?, errors: errors, bookmark: Bookmark.find_by(id: tracker_params[:bookmark_id])}
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
