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
  belongs_to :sc_trackable, polymorphic: true
  validates_uniqueness_of :sc_trackable_id, :scope => [:sc_trackable_type, :user_id, :user_type, :event]
  enum events: {view: 0, like: 1}

  after_create :update_bookmark_analytics

  def self.track(user, entity, event, user_type = user.class.name)
    errors = []
    ActiveRecord::Base.transaction do
      begin
        response = self.create(sc_trackable: entity, user_id: user.id, user_type: user_type, event: SocialTracker.events[event.to_sym])
        errors = response.errors.full_messages
      rescue Exception => ex
        errors << 'Error occured while creating social tracker entry.'
        raise ActiveRecord::Rollback
      end
    end
    return {success: errors.blank?, errors: errors}
  end

  def self.unlike(user, bookmark, event)
    record = self.find_by(user_type: user.class.to_s, user_id: user.id, sc_trackable_type: bookmark.class.to_s, sc_trackable_id: bookmark.id, event: SocialTracker.events[event.to_sym])
    unless record.present?
      record.destroy
      bookmark.decrement!(:likes)
    end
  end

  private
  def update_bookmark_analytics
    self.view? ? bookmark.increment!(:views) : bookmark.increment!(:likes)
  end
end
