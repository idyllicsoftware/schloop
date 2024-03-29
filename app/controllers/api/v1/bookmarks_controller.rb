class Api::V1::BookmarksController < Api::V1::BaseController

  def create
    errors, data = [], {}
    data.merge!(generate_bookmarks_params)
    data.merge!(bookmarks_params)
    begin
      bookmark = Bookmark.create!(data)
      bookmark.reference_bookmark = bookmark.id
      bookmark.save!
    rescue
      errors << "Error occured while inserting new bookmark"
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

  def add_caption
    errors = []
    bookmark = Bookmark.find_by(id: params[:id])
    if bookmark.present?
      bookmark.update_attributes(caption: params[:caption]) if params[:caption].present?
    else
      errors << 'Invalid bookmark id'
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
    bookmark_data = []
    page = params[:page].to_s.to_i || 1
    page_size = 20
    offset = (page * page_size)
    bookmarks = Bookmark.where(teacher_id: @current_user.id, grade_id: params[:grade_id], subject_id: params[:subject_id])
                  .includes(:topic, :teacher).order(id: :desc)

    total_bookmarks = bookmarks.count
    bookmarks = bookmarks.offset(offset).limit(page_size)

    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmarks.ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmarks.ids).pluck(:bookmark_id)

    bookmarks.each do |bookmark|
      formatted_bookmark_data = bookmark.formatted_data
      formatted_bookmark_data.merge!(is_collaborated: collaborated_bookmark_ids.include?(bookmark.id))
      formatted_bookmark_data.merge!(is_followed: followed_bookmark_ids.include?(bookmark.id))

      bookmark_data << formatted_bookmark_data

    end
    pagination_data = {
       page_size: page_size,
       record_count: total_bookmarks,
       total_pages: (total_bookmarks/page_size.to_f).ceil,
       current_page: page
    }
    render json: {success: true, error: nil, data: {bookmark_data: bookmark_data, pagination_data: pagination_data}}
  end


    private

    def bookmarks_params
      params.require(:bookmark).permit(:topic_id, :subject_id, :grade_id, :data)
    end

    def generate_bookmarks_params
      teacher = @current_user
      create_bookmarks_params = {}
      create_bookmarks_params[:teacher_id] = teacher.id
      create_bookmarks_params[:school_id] = teacher.school_id

      is_url = Util::NetworkUtils.valid_url?(bookmarks_params[:data])

      data_type = is_url ? :url : :text
      create_bookmarks_params[:data_type] = Bookmark.data_types[data_type]

      create_bookmarks_params
    end

end