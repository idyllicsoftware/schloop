class TeacherNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(bookmark_id, collaboration_id, teacher)
    bookmark = Bookmark.find_by(id: bookmark_id)

    android_registration_ids = teacher.devices.active.android.pluck(:token)
    if android_registration_ids.present?
      android_options = {
        priority: "high",
        content_available: true,
        data: {
          title: "New Collaboration Added",
          body:  bookmark.title,
          sound: 'default',

          type: 'collaboration',
          id: bookmark_id,
          collaboration_id: collaboration_id
        }
      }

      fcm = FCM.new(FCM_KEY)
      response = fcm.send(android_registration_ids, android_options)
      Rails.logger.info("=================================================")
      Rails.logger.info(fcm)
      Rails.logger.info("--------")
      Rails.logger.info(response)
      Rails.logger.info("=================================================")
    end

    ios_registration_ids = student.parent.devices.active.ios.pluck(:token)
    if ios_registration_ids.present?
      ios_options = {
        notification: {
          title: "New Collaboration Added",
          body:  bookmark.title,
          sound: 'default'
        },
        priority: "high",
        content_available: true,
        data: {
          type: 'collaboration',
          id: bookmark_id,
          collaboration_id: collaboration_id
        }
      }

      fcm = FCM.new(FCM_KEY)
      response = fcm.send(ios_registration_ids, ios_options)
      Rails.logger.info("=================================================")
      Rails.logger.info(fcm)
      Rails.logger.info("--------")
      Rails.logger.info(response)
      Rails.logger.info("=================================================")
    end
  end
end