# == Schema Information
#
# Table name: ecircular_teachers
#
#  id           :integer          not null, primary key
#  ecircular_id :integer
#  teacher_id   :integer
#  school_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EcircularTeacher < ActiveRecord::Base
  belongs_to :ecircular
  belongs_to :teacher
  belongs_to :school
  after_create :send_notification

  def send_notification
    header_hash = {
      title: "New Ecircular Added",
      body:  ecircular.title,
      sound: 'default'
    }
    body_hash = {
      type: 'ecircular',
      id: ecircular_id
    }

    android_registration_ids = teacher.devices.active.android.pluck(:token)
    if android_registration_ids.present?
      android_options = {
        priority: "high",
        content_available: true,
        data: header_hash.merge!(body_hash)
      }
      NotificationWorker.perform_async(android_registration_ids, android_options, TEACHER_FCM_KEY)
    end

    ios_registration_ids = teacher.devices.active.ios.pluck(:token)
    if android_registration_ids.present?
      ios_options = {
        notification: header_hash,
        priority: "high",
        content_available: true,
        data: body_hash
      }
      NotificationWorker.perform_async(ios_registration_ids, ios_options, TEACHER_FCM_KEY)
    end
  end

end
