# == Schema Information
#
# Table name: social_trackers
#
#  id                :integer          not null, primary key
#  sc_trackable_id   :integer
#  sc_trackable_type :string
#  user_id           :integer
#  user_type         :string
#  event             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_sc_all                                                    (sc_trackable_type,sc_trackable_id,user_type,user_id,event) UNIQUE
#  index_social_trackers_on_sc_trackable_type_and_sc_trackable_id  (sc_trackable_type,sc_trackable_id)
#  index_social_trackers_on_user_type_and_user_id                  (user_type,user_id)
#

require 'rails_helper'

RSpec.describe SocialTracker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
