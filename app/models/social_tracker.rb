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

class SocialTracker < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  validates_uniqueness_of :trackable_id, :scope => [:trackable_type, :user_id, :user_type, :event]
  
  enum events: {view: 0, like: 1}
  def self.track(entity, user, event, user_type = user.type)
    tracked_data = self.create(trackable: entity, user_id: user.id, user_type: user_type, event: Tracker.events[event.to_sym])
    return tracked_data.errors.full_messages
  end
end
