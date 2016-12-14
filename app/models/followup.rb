# == Schema Information
#
# Table name: followups
#
#  id               :integer          not null, primary key
#  bookmark_id      :integer          not null
#  followup_message :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_followups_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_ea7649d296  (bookmark_id => bookmarks.id)
#

class Followup < ActiveRecord::Base
  belongs_to :bookmark
end
