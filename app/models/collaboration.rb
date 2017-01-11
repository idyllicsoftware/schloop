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

  def self.index(teacher, offset = nil, page_size = 20)
    collaborated_bookmars = []
    teacher_grade_subjects = teacher.grade_teachers.pluck(:grade_id, :subject_id).uniq
    return collaborated_bookmars if teacher_grade_subjects.blank?

    query_string = ""
    teacher_grade_subjects.each do |grade_subject|
      grade_id = grade_subject.first
      subject_id = grade_subject.second
      query_string += "(grade_id = #{grade_id} and subject_id = #{subject_id})"
      query_string += " or " unless grade_subject.equal?(teacher_grade_subjects.last)
    end
    bookmark_ids = Bookmark.where(query_string).ids
    collaborated_bookmark_ids = Collaboration.where(bookmark_id: bookmark_ids).pluck(:bookmark_id)
    valid_bookmarks = Bookmark.where(id: collaborated_bookmark_ids).order(id: :desc)

    no_of_records = valid_bookmarks.count
    valid_bookmarks = valid_bookmarks.offset(offset).limit(page_size) if offset.present?

    valid_bookmarks.each do |bookmark|
      collaborated_bookmars << bookmark.as_json
    end
    return collaborated_bookmars, no_of_records
  end
end
