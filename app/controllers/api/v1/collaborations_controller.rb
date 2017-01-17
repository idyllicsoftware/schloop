class Api::V1::CollaborationsController < Api::V1::BaseController
  def collaborate
    errors = []
    bookmark_id = params[:bookmark_id]
    collaboration_msg = params[:message]

    bookmark = Bookmark.find_by(id: bookmark_id)
    errors << "Please provide valid bookmark." if bookmark.nil?

    errors << "Bookmark already collaborated." if bookmark.collaboration.present?

    if errors.blank?
      collaboration = Collaboration.create(bookmark: bookmark, collaboration_message: collaboration_msg )
      errors << collaboration.errors.full_messages if collaboration.errors.present?
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

    collaborations, no_of_records = Collaboration.index(@current_user, offset, page_size)

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
        collaborations: collaborations
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
    render json: { success: errors.blank?, errors: {code: 0, message: errors}, bookmark: (bookmark.id rescue 0)}
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
    render json: { success: errors.blank?, errors: {code: 0, message: errors}, bookmark: (bookmark.id rescue 0)}
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
    render json: { success: errors.blank?, errors: {code: 0, message: errors}, bookmark: (bookmark.id rescue 0)}
  end

  def comment
    errors = []
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to comment" if bookmark.blank?

    collaboration = bookmark.collaboration
    errors << "Invalid collaboration to comment" if collaboration.blank?

    message = params[:message]
    errors << "Invalid collaboration to Message" if message.blank?

    if errors.blank?
      begin
        create_comments_params = {
          commentable: collaboration,
          message: message,
          commented_by: @current_user.id
        }
        comment = Comment.create(create_comments_params)
      rescue Exception => e
        errors <<  "Errors while creating new comment"
      end
    end
    render json: {
      success: errors.blank?,
      errors: {code: 0, message: errors},
      data: {comment: (comment.id rescue 0)}
    }
  end

end
