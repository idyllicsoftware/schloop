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
      preview_image_data[:title].present? ? (create_bookmarks_params[:title] = preview_image_data[:title]) : (create_bookmarks_params[:title] = "Schloopmark Web URL")
      create_bookmarks_params[:preview_image_url] = preview_image_data[:preview_image_url]
    else
      create_bookmarks_params[:title] = "Schloopmark Note"
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
    # require 'link_thumbnailer'
    preview_object = LinkThumbnailer.generate(url)
    title = preview_object.title
    if preview_object.images.present?
      preview_image_url = preview_object.images.first.src
    elsif preview_object.url.present?
      preview_image_url = preview_object.url.to_s
    else
      preview_image_url = "image not found"
    end
    { title: title, preview_image_url: preview_image_url }
  end

end