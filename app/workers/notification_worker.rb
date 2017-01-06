class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(circular_id, student_id)
    student = Student.find_by(id: student_id)
    circular = Ecircular.find_by(id: circular_id)

    registration_ids = student.parent.devices.active.pluck(:token)
    options = {
        # notification: {
        #     title: "New Ecircular Added",
        #     body:  circular.title,
        #     sound: 'default'
        # },
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
    response = fcm.send(registration_ids, options)
    Rails.logger.info("=================================================")
    Rails.logger.info(response)
    Rails.logger.info("=================================================")
  end
end