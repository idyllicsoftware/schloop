# == Schema Information
#
# Table name: bookmarks
#
#  id                :integer          not null, primary key
#  title             :string
#  data              :text
#  caption           :text
#  url               :string
#  preview_image_url :string
#  likes             :integer          default(0), not null
#  views             :integer          default(0), not null
#  topic_id          :integer
#  data_type         :integer          default(0), not null
#  school_id         :integer
#  grade_id          :integer
#  subject_id        :integer
#  teacher_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_bookmarks_on_grade_id_and_subject_id  (grade_id,subject_id)
#  index_bookmarks_on_school_id                (school_id)
#  index_bookmarks_on_teacher_id               (teacher_id)
#

class Bookmark < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :topic
  belongs_to :grade
  belongs_to :subject
  belongs_to :school
  has_one :collaboration, dependent: :destroy
  has_one :followup, dependent: :destroy
  has_many :social_trackers, :as => 'sc_trackable', dependent: :destroy


#  index_bookmarks_on_grade_id_and_subject_id  (grade_id,subject_id)
#  index_bookmarks_on_school_id                (school_id)
#  index_bookmarks_on_teacher_id               (teacher_id)
#
  validates :grade_id, presence: true
  validates :subject_id, presence: true
  validates :topic_id, presence: true
  validates :teacher_id, presence: true
  validates :topic_id, presence: true
  #validates :title, presence: true
  ##validates :school_id: presence: true

  validates :likes, :numericality => { only_integer: true ,greater_than_or_equal_to: 0 },:presence => true

  before_create :add_crawl_data

  enum data_type: { text:0, url:1 }

  def self.index(teacher,grade_id, subject_id, topic_id,options={})
    bookmarks_data = []
    bookmarks = Bookmark.where(grade_id: grade_id, subject_id: subject_id, topic_id: topic_id, teacher_id: teacher.id).where(options)
    bookmark_ids = bookmarks.ids
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    followed_bookmark_ids = Followup.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)


    liked_bookmarks = SocialTracker.where(sc_trackable_type: "Bookmark",
                                          sc_trackable_id: collaborated_bookmark_ids,
                                          event: SocialTracker.events[:like])
    liked_bookmark_ids = liked_bookmarks.where(user_type: teacher.class.name, user_id: teacher.id).pluck(:sc_trackable_id)
    teachers_index_by_id = Teacher.where(id: liked_bookmarks.pluck(:user_id)).index_by(&:id)
    liked_bookmarks_group_by_id = liked_bookmarks.group_by do |x| x.sc_trackable_id end
    bookmarks = bookmarks.sort_by(&:created_at).reverse
    bookmarks.each do |bookmark|
      likes = []
      bookmark_formatted_data = bookmark.formatted_data
      is_liked = liked_bookmark_ids.include?(bookmark.id)
      #bookmark_formatted_data.merge!(comments: bookmark.collaboration.formatted_comments)

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
      
      bookmarks_data << bookmark_formatted_data
    end
    return bookmarks_data

  end

  def formatted_data
    is_collaborated = Collaboration.find_by(bookmark_id: self.id).present?
    is_followed = Followup.find_by(bookmark_id: self.id).present?
    { id: id,
      title: title,
      caption: caption,
      data: data,
      type: data_type,
      subject_id: subject_id,
      subject_name: subject.name,
      grade_id: grade_id,
      grade_name: grade.name,
      url: url,
      preview_image_url: preview_image_url,
      likes: likes,
      views: views,
      created_at: created_at,
      topic: {
        topic_id: topic.id,
        topic_title: topic.title
      },
      teacher: {
        id: teacher.id,
        first_name: teacher.first_name,
        last_name: teacher.last_name,
      }
    }
  end

  def add_crawl_data
    begin
      if self.url?
        crawl_data = generate_crawl_data

        self.url = data
        self.title = crawl_data[:title]
        self.caption = crawl_data[:caption]
        self.preview_image_url = crawl_data[:preview_image_url]
      else
        self.title = "Schloopmark Note"
        self.caption = "Schloopmark Note"
      end
    rescue Exception => e
      Rails.logger.debug("Exception in add crawl data: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
    end
  end

  def generate_crawl_data
    begin
      preview_object = LinkThumbnailer.generate(self.data)

      title = preview_object.title || "Schloopmark Web URL"
      caption = preview_object.description || "Schloopmark Web URL"

      if preview_object.images.present?
        preview_image_url = preview_object.images.first.src
      elsif preview_object.url.present?
        preview_image_url = preview_object.url.to_s
      end
    rescue Exception => ex
      Rails.logger.debug("Exception in generate crawl data: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
    end

    return {
      title: title,
      caption: caption,
      preview_image_url: preview_image_url
    }
  end

  def track_bookmark(event, like_state, user)
    errors = []
    begin
      if (event.eql? 'like') and (like_state.eql? "false")
        SocialTracker.unlike(user, self, event)
      else
        SocialTracker.track(user, self, event)
      end
    rescue Exception => ex
      errors << "errors occured while manipulating like and view. #{ex.message}"
    end
    return {success: errors.blank?, errors: errors, bookmark: id}
  end

  def self.associated_bookmark_ids(user)
    grade_subjects = []
    query_string = ""
    if user.is_a?(Parent)
      parent = user
      students = parent.students || []
      students.each do |student|
        student_grade = student.student_profiles.active.last.grade
        subjects = student_grade.subjects rescue []
        subjects.each do |subject|
          grade_subjects << [student_grade.id, subject.id]
        end
      end

      grade_subjects = grade_subjects.uniq
      return [] if grade_subjects.blank?

      grade_subjects.each do |grade_subject|
        grade_id = grade_subject.first
        subject_id = grade_subject.second
        query_string += "(grade_id = #{grade_id} and subject_id = #{subject_id})"
        query_string += " or " unless grade_subject.equal?(grade_subjects.last)
      end
    else
      teacher = user
      teacher_grade_subjects = teacher.grade_teachers.pluck(:grade_id, :subject_id).uniq
      return collaborated_bookmarks if teacher_grade_subjects.blank?

      teacher_grade_subjects.each do |grade_subject|
        grade_id = grade_subject.first
        subject_id = grade_subject.second
        query_string += "(grade_id = #{grade_id} and subject_id = #{subject_id})"
        query_string += " or " unless grade_subject.equal?(teacher_grade_subjects.last)
      end

    end
    bookmark_ids = (Bookmark.where(query_string).ids rescue [])
    return bookmark_ids
  end

end
