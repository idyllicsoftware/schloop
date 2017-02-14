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
  it "should return comment with commenters first name and last name" do
    FactoryGirl.create(:role,:teacher)
    bookmark = FactoryGirl.create(:bookmark)
    teacher = Teacher.create( email: "dmuktesh01+23@gmail.com",school_id: 36, first_name: "bob", middle_name: "the", last_name: "builder", cell_number: "8989890880")
    collaboration =  Collaboration.create(bookmark_id: bookmark.id, collaboration_message: nil) 
    comment = Comment.create(commentable_type: "Collaboration", commentable_id: collaboration.id, commented_by: teacher.id, message: "looks good", commenter: nil)
    comment_data = comment.as_json
    expect(comment_data).to include(:message=>"looks good")
    expect(comment_data).to include(:commenter)
    expect(comment_data[:commenter]).to include(:first_name=>"bob")
    expect(comment_data[:commenter]).to include(:last_name=>"builder")
  end

end
