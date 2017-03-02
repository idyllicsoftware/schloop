# == Schema Information
#
# Table name: activity_shares
#
#  id          :integer          not null, primary key
#  activity_id :integer          not null
#  school_id   :integer          not null
#  teacher_id  :integer          not null
#  grade_id    :integer          not null
#  division_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_activity_shares_on_activity_id                (activity_id)
#  index_activity_shares_on_grade_id_and_division_id   (grade_id,division_id)
#  index_activity_shares_on_school_id                  (school_id)
#  index_activity_shares_on_school_id_and_activity_id  (school_id,activity_id)
#

class ActivityShare < ActiveRecord::Base
  after_create :send_parent_notification

  belongs_to :activity
  belongs_to :school
  belongs_to :teacher
  belongs_to :grade
  belongs_to :division

  def send_parent_notification
    activity = Activity.find_by(id: activity_id)
    division_id = self.division_id
    header_hash = {
      title: 'New Activity Added',
      body: activity.title,
      sound: 'default'
    }
    body_hash = {
      type: 'activity',
      id: activity.id
    }
    associated_parent_ids = []
    student_ids = StudentProfile.where(division_id: division_id).where(status: 'active').pluck(:student_id).uniq
    associated_parent_ids = Student.where(id: student_ids).pluck(:parent_id).uniq
    parents = Parent.where(id: associated_parent_ids)
    parents.each do |parent|
      child_ids = parent.students.where(id: student_ids).pluck(:id)
      android_registration_ids = parent.devices.active.android.pluck(:token)
      child_ids.each do |child_id|
        body_hash[:student_id] = child_id
        if android_registration_ids.present?
          android_options = {
            priority: 'high',
            content_available: true,
            data: header_hash.merge!(body_hash)
          }
          NotificationWorker.perform_async(android_registration_ids, android_options, PARENT_FCM_KEY)
        end
      end
      ios_registration_ids = parent.devices.active.ios.pluck(:token)
      child_ids.each do |child_id|
        body_hash[:student_id] = child_id
        if ios_registration_ids.present?
        ios_options = {
          notification: header_hash,
          priority: 'high',
          content_available: true,
          data: header_hash.merge!(body_hash)
        }
        NotificationWorker.perform_async(ios_registration_ids, ios_options, PARENT_FCM_KEY)
      end
      end
    end
  end
end
