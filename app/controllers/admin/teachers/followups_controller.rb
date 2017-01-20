class Admin::Teachers::FollowupsController < ApplicationController

  def create
    errors = []
    begin
      bookmark = Bookmark.find_by(id: followup_params[:bookmark_id])
      errors << "Please provide valid bookmark." if bookmark.nil?
      errors << "Bookmark already sent to followup." if bookmark.followup.present?
      if errors.blank?
        followup = Followup.create(bookmark: bookmark)
        errors << followup.errors.full_messages if followup.errors.present?
      end
    rescue Exception => e
      errors << "error occured while sharing schloopmark with parents" + ', ' + e.message
    end
    render json: {success: errors.blank?, errors: errors}
  end

  def index
    teacher = current_teacher
    followup_datum = Followup.index_for_web(teacher)
    render json: {success: true, data: followup_datum}
  end

  private
  def followup_params
    params.permit(:bookmark_id)
  end

end
