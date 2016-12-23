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

class Tracker < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  validates_uniqueness_of :trackable_id, :scope => [:trackable_type, :user_id, :user_type, :event]

  enum events: {read: 0}
  def self.track(entity, user, event)
    tracked_data = self.create(trackable: entity, user_id: user.id, user_type: user.type, event: Tracker.events[event.to_sym])
    return tracked_data.errors.full_messages
  end
end
