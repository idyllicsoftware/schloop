class Api::V1::CollaborationsController < Api::V1::BaseController
  def collaborate
    errors = []
    bookmark_id = params[:bookmark_id]
    collaboration_msg = params[:message]

    bookmark = Bookmark.find_by(id: bookmark_id)
    errors << "Please provide valid bookmark" if bookmark.nil?

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
end
