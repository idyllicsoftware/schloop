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

require 'rails_helper'

RSpec.describe Collaboration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
