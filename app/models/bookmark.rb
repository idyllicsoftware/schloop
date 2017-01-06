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
  has_one :collaboration, :dependent => :destroy
  has_many :social_trackers, :as => 'sc_trackable', :dependent => :destroy


#  index_bookmarks_on_grade_id_and_subject_id  (grade_id,subject_id)
#  index_bookmarks_on_school_id                (school_id)
#  index_bookmarks_on_teacher_id               (teacher_id)
#
  validates :grade_id, presence: true
  validates :subject_id, presence: true
  validates :topic_id, presence: true
  validates :teacher_id, presence: true
  #validates :title, presence: true
  ##validates :school_id: presence: true 
  validates :likes, :numericality => { only_integer: true ,greater_than_or_equal_to: 0 },:presence => true

  before_create :add_crawl_data

  enum data_type: { text:0, url:1 }
  
  def self.index(user, topic_id)
    bookmarks = self.where("topic_id = ? AND (teacher_id = 0 OR teacher_id = ?)",
                                topic_id, user.id).order('updated_at desc')
    return bookmarks
  end

  def add_crawl_data
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

  end

  def generate_crawl_data
    preview_object = LinkThumbnailer.generate(self.data)

    title = preview_object.title || "Schloopmark Web URL"
    caption = preview_object.description || "Schloopmark Web URL"

    if preview_object.images.present?
      preview_image_url = preview_object.images.first.src
    elsif preview_object.url.present?
      preview_image_url = preview_object.url.to_s
    end

    return {
      title: title,
      caption: caption,
      preview_image_url: preview_image_url
    }
  end

end
