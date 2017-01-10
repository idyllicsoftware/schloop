class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(circular_id, student_id)
    student = Student.find_by(id: student_id)
    circular = Ecircular.find_by(id: circular_id)

    android_registration_ids = student.parent.devices.active.android.pluck(:token)
    if android_registration_ids.present?
      android_options = {
        priority: "high",
        content_available: true,
        data: {
          title: "New Ecircular Added",
          body:  circular.title,
          sound: 'default',

          type: 'ecircular',
          id: circular_id,
          student_id: student_id
        }
      }

      fcm = FCM.new(FCM_KEY)
      response = fcm.send(android_registration_ids, android_options)
      Rails.logger.info("=================================================")
      Rails.logger.info(response)
      Rails.logger.info("=================================================")
    end

    ios_registration_ids = student.parent.devices.active.ios.pluck(:token)
    if ios_registration_ids.present?
      ios_options = {
        notification: {
            title: "New Ecircular Added",
            body:  circular.title,
            sound: 'default'
        },
        priority: "high",
        content_available: true,
        data: {
          type: 'ecircular',
          id: circular_id,
          student_id: student_id
        }
      }

      fcm = FCM.new(FCM_KEY)
      response = fcm.send(ios_registration_ids, ios_options)
      Rails.logger.info("=================================================")
      Rails.logger.info(response)
      Rails.logger.info("=================================================")
    end
  end
end