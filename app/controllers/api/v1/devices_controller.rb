class Api::V1::DevicesController < Api::V1::BaseController
  def register
    errors = []
    errors << "Token must be present" if params[:token].blank?
    begin
      Device.create!(register_params) if errors.blank?
    rescue Exception => ex
      errors << ex.message
    end
    if errors.blank?
      render json: {
          success: true,
          error: nil,
          data: {}
      }
    else
      render json: {
          success: false,
          error:  {
              code: 0,
              message: errors
          },
          data: nil
      }
    end
  end

  def de_register
    errors = []
    token = params[:token]
    device = Device.find_by(token: token)
    if device.blank?
      errors << "No device with token found"
      render json: {
          success: false,
          error:  {
              code: 0,
              message: errors
          },
          data: nil
      }
    else
      device.inactive!
      render json: {
          success: true,
          error: nil,
          data: {}
      }
    end
  end

    private
    def register_params
      {
        deviceable: @current_user,
        device_type: Device.device_types[params[:device_type].to_sym],
        token: params[:token],
        os_version: params[:os_version]
      }
    end
end
