class Api::V1::FollowupsController < Api::V1::BaseController

  def followup
    errors = []
    bookmark_id = params[:bookmark_id]
    followup_message = params[:message]

    bookmark = Bookmark.find_by(id: bookmark_id)
    errors << "Please provide valid bookmark." if bookmark.nil?

    errors << "Bookmark already sent to followup." if bookmark.followup.present?

    if errors.blank?
      followup = Followup.create(bookmark: bookmark, followup_message: followup_message )
      errors << followup.errors.full_messages if followup.errors.present?
    end
    if errors.blank?
      render json: {
        success: true,
        error: nil,
        data: {
          id: bookmark.id
        }
      }
    else
      render json: {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
  end

  def index
    page = params[:page].to_s.to_i || 1
    page_size = 20
    offset = (page * page_size)

    student = Student.find_by(id: params[:student_id]) rescue nil
    user = student || @current_user
    followups, no_of_records = Followup.index(user, offset, page_size)

    pagination_data = {
      page_size: page_size,
      record_count: no_of_records,
      total_pages: (no_of_records/page_size.to_f).ceil,
      current_page: page
    }

    render json: {
      success: true,
      error: nil,
      data: {
        pagination_data: pagination_data,
        collaborations: followups
      }
    }
  end

  def like
    errors = []
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to track" if bookmark.blank?
    if errors.blank?
      event = 'like'
      like_state = "true"
      bookmark.track_bookmark(event, like_state, @current_user)
    end
    bookmark.reload
    render json: { success: errors.blank?, errors: errors, bookmark: (bookmark.id rescue 0)}
  end

  def unlike
    errors = []
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to track" if bookmark.blank?
    if errors.blank?
      event = 'like'
      like_state = "false"
      bookmark.track_bookmark(event, like_state, @current_user)
    end
    bookmark.reload
    render json: { success: errors.blank?, errors: errors, bookmark: (bookmark.id rescue 0)}
  end

  def view
    errors = []
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to track" if bookmark.blank?
    if errors.blank?
      event = 'view'
      like_state = "false"
      bookmark.track_bookmark(event, like_state, @current_user)
    end
    render json: { success: errors.blank?, errors: errors, bookmark: (bookmark.id rescue 0)}
  end

  def comment
    errors = []
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to comment" if bookmark.blank?

    followup = bookmark.followup
    errors << "Invalid followup to comment" if followup.blank?

    message = params[:message]
    errors << "Invalid collaboration to Message" if message.blank?

    if errors.blank?
      begin
        create_comments_params = {
          commentable: followup,
          message: message,
          commented_by: @current_user.id
        }
        comment = Comment.create(create_comments_params)
      rescue Exception => e
        errors <<  "Errors while creating new comment"
      end
    end
    render json: {success:errors.blank?, errors: {code: 0, message: errors}, data: {comment: (comment.id rescue 0)}}
  end

end
