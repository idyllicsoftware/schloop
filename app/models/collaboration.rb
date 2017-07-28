# == Schema Information
#
# Table name: collaborations
#
#  id                    :integer          not null, primary key
#  bookmark_id           :integer
#  collaboration_message :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_collaborations_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_002aed23cd  (bookmark_id => bookmarks.id)
#

class Collaboration < ActiveRecord::Base
  belongs_to :bookmark
  has_many :comments, as: :commentable, :dependent => :delete_all
  validates_uniqueness_of :bookmark_id

  after_create :send_notification

  def self.index(teacher, offset = nil, page_size = 20)
    collaborated_bookmarks = []
    bookmark_ids = Bookmark.associated_bookmark_ids(teacher)
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    valid_bookmarks = Bookmark.where(id: collaborated_bookmark_ids).includes(:collaboration, :grade, :subject, :topic, :teacher).order(id: :desc)
    schloop_marked_bookmark_ids = Bookmark.where(id: collaborated_bookmark_ids, teacher_id: teacher.id).pluck(:reference_bookmark)

    no_of_records = valid_bookmarks.count
    valid_bookmarks = valid_bookmarks.offset(offset).limit(page_size) if offset.present?

    liked_bookmarks = SocialTracker.where(sc_trackable_type: "Bookmark",
                                          sc_trackable_id: collaborated_bookmark_ids,
                                          user_type: 'Teacher',
                                          event: SocialTracker.events[:like])

    liked_bookmark_ids = liked_bookmarks.where(user_type: teacher.class.name, user_id: teacher.id).pluck(:sc_trackable_id)

    teachers_index_by_id = Teacher.where(id: liked_bookmarks.pluck(:user_id)).index_by(&:id)
    liked_bookmarks_group_by_id = liked_bookmarks.group_by do |x| x.sc_trackable_id end
    valid_bookmarks = valid_bookmarks.sort_by{|bookmark| bookmark.collaboration.created_at}.reverse
    valid_bookmarks.each do |bookmark|
      likes = []
      bookmark_formatted_data = bookmark.formatted_data
      is_liked = liked_bookmark_ids.include?(bookmark.id)
      bookmark_formatted_data.merge!(comments: bookmark.collaboration.formatted_comments)

      liked_users = liked_bookmarks_group_by_id[bookmark.id] || []

      liked_users.each do |liked_user|
        teacher = teachers_index_by_id[liked_user.user_id]
        likes << {
          id: teacher.id,
          first_name: teacher.first_name,
          last_name: teacher.last_name
        } 
      end
      bookmark_formatted_data.merge!(likes: likes)
      bookmark_formatted_data.merge!(is_liked: is_liked)
      bookmark_formatted_data.merge!(is_collaborated: collaborated_bookmark_ids.include?(bookmark.id))
      bookmark_formatted_data.merge!(is_followedup: followed_bookmark_ids.include?(bookmark.id))
      bookmark_formatted_data.merge!(is_schloopmarked: schloop_marked_bookmark_ids.include?(bookmark.id))

      collaborated_bookmarks << bookmark_formatted_data
    end

    return collaborated_bookmarks, no_of_records
  end


  def formatted_comments
    comments_data = []
    collaboration_comments = comments.order('created_at asc')
    return comments_data if collaboration_comments.blank?
    teacher_index_by_id = Teacher.where(id: comments.pluck(:commented_by)).index_by(&:id)
    collaboration_comments.each do |comment|
      teacher = teacher_index_by_id[comment.commented_by]
      if teacher.present?
        comment_data = comment.as_json
        comment_data[:commenter][:first_name] = teacher.first_name
        comment_data[:commenter][:last_name] = teacher.last_name
        comments_data << comment_data
      end
    end
    return comments_data
  end

  def self.add_to_my_topics_data(bookmark,teacher,topic)
    data = {
      title: bookmark.title,
      caption: bookmark.caption,
      data: bookmark.data,
      data_type: bookmark.data_type,
      url: bookmark.url,
      preview_image_url: bookmark.preview_image_url,
      grade_id: bookmark.grade_id,
      subject_id: bookmark.subject_id,
      topic_id: topic.id,
      school_id: teacher.school_id,
      teacher_id: teacher.id,
      reference_bookmark: bookmark.id
    }
    return data
  end

  def send_notification
    bookmark = self.bookmark
    grade_id = bookmark.grade_id
    subject_id = bookmark.subject_id
    header_hash = {
      title: "New Collaboration Added",
      body:  bookmark.title,
      sound: 'default',
    }
    body_hash = {
      type: 'collaboration',
      id: bookmark.id,
      collaboration_id: self.id
    }
    associated_teacher_ids = GradeTeacher.where(grade_id:grade_id, subject_id: subject_id).pluck(:teacher_id)
    teachers = Teacher.where(id: associated_teacher_ids)
    teachers.each do |teacher|
      android_registration_ids = teacher.devices.active.android.pluck(:token)
      if android_registration_ids.present?
        android_options = {
          priority: "high",
          content_available: true,
          data: header_hash.merge!(body_hash)
        }
        NotificationWorker.perform_async(android_registration_ids, android_options, TEACHER_FCM_KEY)
      end

      ios_registration_ids = teacher.devices.active.ios.pluck(:token)
      if ios_registration_ids.present?
        ios_options = {
          notification: header_hash,
          priority: "high",
          content_available: true,
          data: body_hash
        }
        NotificationWorker.perform_async(ios_registration_ids, ios_options, TEACHER_FCM_KEY)
      end
    end
  end

end
