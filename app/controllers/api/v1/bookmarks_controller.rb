class Api::V1::BookmarksController < Api::V1::BaseController

  def create
    errors, data = [], {}
    data.merge!generate_bookmarks_params
    data.merge!bookmarks_params
    begin
      Bookmark.create!(data)
    rescue
      errors << "error occured while inserting new bookmark"
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def add_caption
    errors = nil
    bookmark = Bookmark.find_by(id: params[:id])
    if bookmark.present?
      bookmark.update_attributes(caption: params[:caption])
    else
      errors = 'Invalid bookmark id'
    end
    render json: { success: errors.blank?, errors: errors }
  end

  def index
    page = params[:page].to_s.to_i || 1
    page_size = 20
    offset = (page * page_size)
    bookmarks = Bookmark.where(grade_id: params[:grade_id], subject_id: params[:subject_id]).offset(offset).limit(page_size)
    render json: {success: true, error: [], data: nil} and return unless bookmarks.present?
    bookmark_data = []
    total_bookmarks = bookmarks.count
    bookmarks.each do |bookmark|
      bookmark_data << { id: bookmark.id,
                        title: bookmark.title,
                        caption: bookmark.caption,
                        data: bookmark.data,
                        type: bookmark.data_type,
                        subject_id: bookmark.subject_id,
                        grade_id: bookmark.grade_id,
                        preview_image_url: bookmark.preview_image_url,
                        created_at: bookmark.created_at,
                        topic: {
                            topic_id: bookmark.topic.id,
                            topic_title: bookmark.topic.title
                        },
                        teacher: {
                            id: bookmark.teacher.id,
                            first_name: bookmark.teacher.first_name,
                            last_name: bookmark.teacher.last_name
                        }

      }
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
    is_url = uri?(bookmarks_params[:data])
    data_type = is_url ? :url : :text
    create_bookmarks_params[:data_type] = Bookmark.data_types[data_type]
    if is_url
      preview_image_data = get_preview_image_url(bookmarks_params[:data])
      create_bookmarks_params[:title] = preview_image_data[:title]
      create_bookmarks_params[:caption] = preview_image_data[:caption]
      create_bookmarks_params[:preview_image_url] = preview_image_data[:preview_image_url]
    else
      create_bookmarks_params[:title] = "Schloopmark Note"
      create_bookmarks_params[:caption] = "Schloopmark Note"
    end
    create_bookmarks_params
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue
    false
  end

  def get_preview_image_url(url)
    preview_object = LinkThumbnailer.generate(url)
    title = preview_object.title || "Schloopmark Web URL"
    caption = preview_object.description || "Schloopmark Web URL"
    if preview_object.images.present?
      preview_image_url = preview_object.images.first.src
    elsif preview_object.url.present?
      preview_image_url = preview_object.url.to_s
    else
      preview_image_url = "image not found"
    end
    { title: title, preview_image_url: preview_image_url, caption: caption }
  end

end