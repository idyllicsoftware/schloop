class Api::V1::ContentsController < ApplicationController

	def index
		errors = []
		@contents = Content.search(params[:filter])
		if errors.blank?
			response = {
				success: true,
     		    error:  nil,
				data: {}
			}
		else
			response = {
				success: false,
        		error:  {
          			code: 0,
          			message: errors.flatten
        		},
				data: nil
			}
		end
		render json: response
	end

	private
    def content_params
      params.permit(:grade, :subject, :topic, :activity_title, :catagory, :teachers, :pre_requisites, :reference_image)
	end

end
