class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(registration_ids, options, fcm_key)
      fcm = FCM.new(fcm_key)
      response = fcm.send(registration_ids, options)
      Rails.logger.info("=================================================")
      Rails.logger.info(response)
      Rails.logger.info("=================================================")
  end
end