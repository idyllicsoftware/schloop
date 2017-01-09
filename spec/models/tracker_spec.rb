# == Schema Information
#
# Table name: trackers
#
#  id             :integer          not null, primary key
#  trackable_id   :integer
#  trackable_type :string
#  user_id        :integer
#  user_type      :string
#  event          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_all                                          (trackable_type,trackable_id,user_type,user_id,event) UNIQUE
#  index_trackers_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackers_on_user_type_and_user_id            (user_type,user_id)
#

require 'rails_helper'

RSpec.describe Tracker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
