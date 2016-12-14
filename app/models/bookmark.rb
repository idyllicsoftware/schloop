# == Schema Information
#
# Table name: bookmarks
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  data              :text             not null
#  data_type         :integer          not null
#  caption           :text             default(""), not null
#  teacher_id        :integer          not null
#  topic_id          :integer          not null
#  preview_image_url :string           default(""), not null
#  views             :integer          default(0), not null
#  likes             :integer          default(0), not null
#  grade_id          :integer          not null
#  subject_id        :integer          not null
#  school_id         :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_bookmarks_on_grade_id    (grade_id)
#  index_bookmarks_on_school_id   (school_id)
#  index_bookmarks_on_subject_id  (subject_id)
#  index_bookmarks_on_teacher_id  (teacher_id)
#  index_bookmarks_on_topic_id    (topic_id)
#
# Foreign Keys
#
#  fk_rails_19e7814100  (subject_id => subjects.id)
#  fk_rails_272c56774b  (topic_id => topics.id)
#  fk_rails_80f0ba3a53  (school_id => schools.id)
#  fk_rails_abb97e0bbf  (grade_id => grades.id)
#  fk_rails_fbd6c28981  (teacher_id => teachers.id)
#

class Bookmark < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :topic
  belongs_to :grade
  belongs_to :subject
  belongs_to :school
end
