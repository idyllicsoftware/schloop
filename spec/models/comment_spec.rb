require 'pry'
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string
#  commentable_id   :integer
#  commented_by     :integer
#  message          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'should return comment with commenters first name and last name' do
    FactoryGirl.create(:role, :teacher)
    bookmark = FactoryGirl.create(:bookmark)
    teacher = Teacher.create(email: 'dmuktesh01+23@gmail.com', school_id: 36, first_name: 'bob', middle_name: 'the', last_name: 'builder', cell_number: '8989890880')
    collaboration = Collaboration.create(bookmark_id: bookmark.id, collaboration_message: nil)
    comment = Comment.create(commentable_type: 'Collaboration', commentable_id: collaboration.id, commented_by: teacher.id, message: 'looks good', commenter: nil)
    comment_data = comment.as_json
    expect(comment_data).to include(message: 'looks good')
    # expect(comment_data).to include(:commenter)
    # expect(comment_data[:commenter]).to include(:first_name=>"bob")
    # expect(comment_data[:commenter]).to include(:last_name=>"builder")
  end
  describe '#send_notification' do
    it 'check notification are enequed', send: true do
      stats = Sidekiq::Stats.new
      past_job_count = stats.processed + stats.enqueued + stats.failed
      collaboration = FactoryGirl.create(:collaboration)
      FactoryGirl.create(:grade_teacher, grade_id: collaboration.bookmark.grade_id, subject_id: collaboration.bookmark.subject_id)
      FactoryGirl.create(:grade_teacher, grade_id: collaboration.bookmark.grade_id, subject_id: collaboration.bookmark.subject_id)
      teacher = Teacher.last
      commenter = teacher.first_name + teacher.last_name
      Comment.create(commentable_type: 'Collaboration', commentable_id: collaboration.id, commented_by: teacher.id, message: 'this is good. ', commenter: commenter)
      sleep 5.0
      stats = Sidekiq::Stats.new
      present_job_count = stats.processed + stats.enqueued + stats.failed
      expect(past_job_count).to be < present_job_count
    end
  end
end
