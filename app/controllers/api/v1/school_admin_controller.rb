class Api::V1::SchoolAdminController < Api::V1::BaseController
  skip_before_filter :authenticate, only: [:register]

  def register

  end

    private
    def school_admin_params
      params.require(:user).permit(:school_id, :email, :first_name, :middle_name, :last_name, :work_number, :cell_number)
    end
end
