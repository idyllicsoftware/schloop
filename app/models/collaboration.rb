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

  def self.index(teacher, offset = nil, page_size = 20)
    collaborated_bookmarks = []
    teacher_grade_subjects = teacher.grade_teachers.pluck(:grade_id, :subject_id).uniq
    return collaborated_bookmarks if teacher_grade_subjects.blank?

    query_string = ""
    teacher_grade_subjects.each do |grade_subject|
      grade_id = grade_subject.first
      subject_id = grade_subject.second
      query_string += "(grade_id = #{grade_id} and subject_id = #{subject_id})"
      query_string += " or " unless grade_subject.equal?(teacher_grade_subjects.last)
    end
    bookmark_ids = Bookmark.where(query_string).ids
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    valid_bookmarks = Bookmark.where(id: collaborated_bookmark_ids).includes(:collaboration).order(id: :desc)

    no_of_records = valid_bookmarks.count
    valid_bookmarks = valid_bookmarks.offset(offset).limit(page_size) if offset.present?

    liked_bookmarks = SocialTracker.where(sc_trackable_type: "Bookmark",
                                          sc_trackable_id: collaborated_bookmark_ids,
                                          event: SocialTracker.events[:like])

    liked_bookmark_ids = liked_bookmarks.where(user_type: teacher.class.name, user_id: teacher.id).pluck(:sc_trackable_id)

    teachers_index_by_id = Teacher.where(id: liked_bookmarks.pluck(:user_id)).index_by(&:id)
    liked_bookmarks_group_by_id = liked_bookmarks.group_by do |x| x.sc_trackable_id end

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
      comment_data = comment.as_json
      comment_data[:commenter][:first_name] = teacher.first_name
      comment_data[:commenter][:last_name] = teacher.last_name
      comments_data << comment_data
    end
    return comments_data
  end

end
