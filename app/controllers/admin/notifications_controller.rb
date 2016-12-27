class Admin::NotificationsController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => "admin@notif"

  def show
  end

  def send_notification
    key = 'AIzaSyDe3HNn_owddmmaGABY-hXRLaMbFOqYiOo'
    token = params[:token]
    reg_ids = [token]
    options = {
        notification: {
            title: params[:title],
            body: params[:body],
            sound: 'default'
        },
        data: {
          type: params[:type],
          id: params[:id],
          student_id: params[:student_id]
        }
    }

    fcm = FCM.new(key)
    response = fcm.send(reg_ids, options)
    Rails.logger.info("=================================================")
    Rails.logger.info(response)
    Rails.logger.info("=================================================")
    flash[:alert] = "Notification send successfully."
    redirect_to :admin_show_nofifcation
  end
end
