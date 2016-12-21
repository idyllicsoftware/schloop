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
        },
        data: {
          type: params[:type],
          id: params[:id]
        }
    }

    fcm = FCM.new(key)
    response = fcm.send(reg_ids, options)
    flash[:alert] = "Notification send successfully."
    redirect_to :admin_show_nofifcation
  end
end
