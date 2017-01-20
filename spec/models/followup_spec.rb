# == Schema Information
#
# Table name: followups
#
#  id          :integer          not null, primary key
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_followups_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_ea7649d296  (bookmark_id => bookmarks.id)
#

require 'rails_helper'

RSpec.describe Followup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
