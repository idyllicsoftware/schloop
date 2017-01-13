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

    followups, no_of_records = Followup.index(@current_user, offset, page_size)

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

end
