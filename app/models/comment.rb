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
#  commenter        :string
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  validates :message, :presence => true, :length => { :maximum => 400 }

  def as_json
  {
    id: id,
    message: message,
    commenter: {
      id: commented_by,
      first_name: "",
      last_name: "",
    },
    created_at: created_at,
    updated_at: updated_at
  }
  end
end
