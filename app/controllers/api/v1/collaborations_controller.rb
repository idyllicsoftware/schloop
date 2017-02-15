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

  def get_comment
    errors, comments = [], []

    collaboration =  Collaboration.find_by(id: params[:collaboration_id])
    errors << "Invalid collaboration to comment" if collaboration.blank?

    if errors.blank?
      collaboration_comments = collaboration.comments.order('created_at asc')
      teacher_index_by_id = Teacher.where(id: collaboration.comments.pluck(:commented_by)).index_by(&:id)
      collaboration_comments.each do |comment|
        teacher = teacher_index_by_id[comment.commented_by]
        if teacher.present?
          comment_data = comment.as_json
          comment_data[:commenter][:first_name] = teacher.first_name
          comment_data[:commenter][:last_name] = teacher.last_name
          comments << comment_data
        end
      end
    end
    render json: {
      success: errors.blank?,
      errors: {code: 0, message: errors},
      data: {comments: comments}
    }
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

  def add_to_my_bookmarks
    errors, new_bookmark = [], nil
    bookmark = Bookmark.find_by(id: params[:bookmark_id])
    errors << "Invalid bookmark to process." if bookmark.blank?

    teacher = @current_user
    if Bookmark.find_by(reference_bookmark: bookmark.reference_bookmark, teacher_id: teacher.id).present?
      errors << "bookmark already added to your list"
    end
    if errors.blank?
      ActiveRecord::Base.transaction do
        begin
          master_subject = Subject.find_by(id: bookmark.subject_id).master_subject
          master_grade = Grade.find_by(id: bookmark.grade_id).master_grade
          topic = Topic.find_by(teacher_id: teacher.id, master_grade_id: master_grade.id, master_subject_id: master_subject.id, title: bookmark.topic.title)
          if topic.blank?
            topic = Topic.create(title: bookmark.topic.title, teacher_id: teacher.id, master_subject_id: master_subject.id, master_grade_id: master_grade.id)
          end
          bookmark_create_params = Collaboration.add_to_my_topics_data(bookmark, teacher, topic)
          new_bookmark = Bookmark.create!(bookmark_create_params)
        rescue Exception => ex
          errors << 'Errors occured while adding bookmark to my topics'
          raise ActiveRecord::Rollback
        end
      end
    end
    render json: {success: errors.blank?, error: {message: errors}, data: {bookmark_id: (new_bookmark.id rescue 0)}}
  end

end
