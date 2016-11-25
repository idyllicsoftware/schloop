class Api::V1::ActivitiesController < Api::V1::BaseController


	def index

  end

  def grade_subjects

    profile_data = {
      id: @current_user.id,
      first_name: @current_user.first_name,
      last_name: @current_user.last_name,
      email: @current_user.email,
      phone: @current_user.cell_number,
      school_id: @current_user.school_id,
      grade_divisions: [{grade_id: 1,
                         grade_name: 'grade one',
                         divisions: [
                           {id: 1, name: 'A'},
                           {id: 2, name: 'B'},
                           {id: 3, name: 'C'},
                           {id: 4, name: 'D'}] },
                        {grade_id: 2,
                         grade_name: 'grade two',
                         divisions: [
                           {id: 5, name: 'A'},
                           {id: 6, name: 'B'}] }]
    }

    render json: {
      success: true,
      error: nil,
      data: {
        profile: profile_data
      }
    }
  end

	private
    def activity_params
      params.permit(:grade, :subject, :topic, :activity_title, :category, :teaches, :pre_requisites, :reference_image)
	end

end
