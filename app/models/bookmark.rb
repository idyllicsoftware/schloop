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

  enum data_type: { text: 0, url: 1 }

  before_save :add_crawl_data

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