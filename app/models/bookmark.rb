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
#  index_bookmarks_on_grade_id_and_subject_id  (grade_id,subject_id)
#  index_bookmarks_on_school_id                (school_id)
#  index_bookmarks_on_teacher_id               (teacher_id)
#

  validates :grade_id, presence: true
  validates :subject_id, presence: true
  validates :topic_id, presence: true
  validates :teacher_id, presence: true
  #validates :school_id: presence: true 

  enum data_type: { text:0, url:1 }
  def self.index(user, topic_id)
    bookmarks = self.where("topic_id = ? AND (teacher_id = 0 OR teacher_id = ?)",
                                topic_id, user.id).order('updated_at desc')
    return bookmarks
  end

end
