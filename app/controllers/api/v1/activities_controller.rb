class Api::V1::ActivitiesController < ApplicationController

	def index
		errors = []
		filter_options = {}
		filter_options << Activity.grades
		filter_options << Activity.subjects
		@activities = activity.all
		response = {
			success: true,
     	    error:  nil,
			data: @activities
		}

		render json: response
	end
=begin
	def show
		id = params[:activity_id]
		activity = activity.where(id: id)
		attachments = Attachment.where(attachable_type: , attachable_id: activity.id)
		response = {
			grade: activity.grade,
			subject: activity.subject,
			topic: activity.topic,
			activity_title: activity.activity_title,
			catagory: activity.catagory,
			teachers: activity.teachers,
			pre_requisites: activity.pre_requisites
		}
		render json: activity
	end
=end	
	private
    def activity_params
      params.permit(:grade, :subject, :topic, :activity_title, :catagory, :teachers, :pre_requisites, :reference_image)
	end

end
