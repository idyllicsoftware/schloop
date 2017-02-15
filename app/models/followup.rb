# == Schema Information
#
# Table name: followups
#
#  id               :integer          not null, primary key
#  bookmark_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  followup_message :string
#
# Indexes
#
#  index_followups_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_ea7649d296  (bookmark_id => bookmarks.id)
#

class Followup < ActiveRecord::Base
  belongs_to :bookmark
  has_many :comments, as: :commentable, :dependent => :delete_all
  validates_uniqueness_of :bookmark_id

  after_create :send_notification

  def self.index_for_web(parent)
    followedup_bookmarks = []
    bookmark_ids = Bookmark.associated_bookmark_ids(parent)
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    valid_bookmarks = Bookmark.where(id: followed_bookmark_ids).includes(:followup).order(id: :desc)

    liked_bookmarks = SocialTracker.where(sc_trackable_type: "Bookmark",
                                          sc_trackable_id: followed_bookmark_ids,
                                          user_type: 'Parent',
                                          event: SocialTracker.events[:like])

    liked_bookmark_ids = liked_bookmarks.where(user_type: parent.class.name, user_id: parent.id).pluck(:sc_trackable_id)

    parents_index_by_id = Parent.where(id: liked_bookmarks.pluck(:user_id)).index_by(&:id)
    liked_bookmarks_group_by_id = liked_bookmarks.group_by do |x| x.sc_trackable_id end
    valid_bookmarks = valid_bookmarks.sort_by{|bookmark| bookmark.followup.created_at}.reverse
    valid_bookmarks.each do |bookmark|
      likes = []
      bookmark_formatted_data = bookmark.formatted_data
      is_liked = liked_bookmark_ids.include?(bookmark.id)
      bookmark_formatted_data.merge!(comments: bookmark.followup.formatted_comments)

      liked_users = liked_bookmarks_group_by_id[bookmark.id] || []

      liked_users.each do |liked_user|
        parent = parents_index_by_id[liked_user.user_id]
        if parent.present?
          likes << {
            id: parent.id,
            first_name: parent.first_name,
            last_name: parent.last_name
          } 
        end
      end
      bookmark_formatted_data.merge!(likes: likes)
      bookmark_formatted_data.merge!(is_liked: is_liked)
      bookmark_formatted_data.merge!(is_collaborated: collaborated_bookmark_ids.include?(bookmark.id))
      bookmark_formatted_data.merge!(is_followedup: followed_bookmark_ids.include?(bookmark.id))

      followedup_bookmarks << bookmark_formatted_data
    end

    return followedup_bookmarks
  end

  def self.index(user, offset = nil, page_size = 20)
    followed_bookmarks = []
    bookmark_ids = Bookmark.associated_bookmark_ids(user)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    valid_bookmarks = Bookmark.where(id: followed_bookmark_ids).includes(:followup).order(id: :desc)
    no_of_records = valid_bookmarks.count
    valid_bookmarks = valid_bookmarks.offset(offset).limit(page_size) if offset.present?

    liked_bookmarks = SocialTracker.where(sc_trackable_type: "Bookmark",
                                          sc_trackable_id: followed_bookmark_ids,
                                          event: SocialTracker.events[:like])

    if user.is_a?(Student)
      parent = user.parent
      liked_bookmark_ids = liked_bookmarks.where(user_type: parent.class.name, user_id: parent.id).pluck(:sc_trackable_id)
    else
      liked_bookmark_ids = liked_bookmarks.where(user_type: user.class.name, user_id: user.id).pluck(:sc_trackable_id)
    end

    users_index_by_id = Parent.where(id: liked_bookmarks.pluck(:user_id)).index_by(&:id)

    liked_bookmarks_group_by_id = liked_bookmarks.group_by do |x| x.sc_trackable_id end
    valid_bookmarks = valid_bookmarks.sort_by{|bookmark| bookmark.followup.created_at}.reverse
    valid_bookmarks.each do |bookmark|
      likes = []
      bookmark_formatted_data = bookmark.formatted_data
      is_liked = liked_bookmark_ids.include?(bookmark.id)
      bookmark_formatted_data.merge!(comments: bookmark.followup.formatted_comments)

      liked_users = liked_bookmarks_group_by_id[bookmark.id] || []

      liked_users.each do |liked_user|
        like_user = users_index_by_id[liked_user.user_id]
        likes << {
          id: like_user.id,
          first_name: like_user.first_name,
          last_name: like_user.last_name
        } if like_user.present?
      end
      bookmark_formatted_data.merge!(likes: likes)
      bookmark_formatted_data.merge!(is_liked: is_liked)
      bookmark_formatted_data.merge!(is_collaborated: followed_bookmark_ids.include?(bookmark.id))
      bookmark_formatted_data.merge!(is_followedup: followed_bookmark_ids.include?(bookmark.id))

      followed_bookmarks << bookmark_formatted_data
    end

    return followed_bookmarks, no_of_records
  end

  def formatted_comments
    comments_data = []
    followup_comments = comments.order('created_at asc')
    return comments_data if followup_comments.blank?
    parents_index_by_id = Parent.where(id: comments.pluck(:commented_by)).index_by(&:id)
    followup_comments.each do |comment|
      parent = parents_index_by_id[comment.commented_by]
      if parent.present?
        comment_data = comment.as_json
        comment_data[:commenter][:first_name] = parent.first_name 
        comment_data[:commenter][:last_name] = parent.last_name
        comments_data << comment_data
      end
    end
    return comments_data
  end

  def send_notification
    bookmark = self.bookmark
    grade_id = bookmark.grade_id

    header_hash = {
      title: "New Followup Added",
      body:  bookmark.title,
      sound: 'default',
    }
    body_hash = {
      type: 'followup',
      id: bookmark.id,
      followup_id: self.id
    }
    associated_student_ids = StudentProfile.where(grade_id: grade_id).pluck(:student_id)
    students = Student.active.where(id: associated_student_ids)

    students.each do |student|
      body_hash.merge!(student_id: student.id)
      android_registration_ids = student.parent.devices.active.android.pluck(:token)
      if android_registration_ids.present?
        android_options = {
          priority: "high",
          content_available: true,
          data: header_hash.merge!(body_hash)
        }
        NotificationWorker.perform_async(android_registration_ids, android_options, PARENT_FCM_KEY)
      end

      ios_registration_ids = student.parent.devices.active.ios.pluck(:token)
      if ios_registration_ids.present?
        ios_options = {
          notification: header_hash,
          priority: "high",
          content_available: true,
          data: body_hash
        }
        NotificationWorker.perform_async(ios_registration_ids, ios_options, PARENT_FCM_KEY)
      end
    end
  end

end
