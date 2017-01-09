class Admin::Teachers::FollowupsController < ApplicationController

  def create
    errors = []
    begin
      bookmark = Bookmark.find_by(id: followup_params)
      grade = bookmark.grade
      student_profiles = StudentProfile.where(grade_id: grade.id).where(status: active).pluck(:student_id)
      
    rescue Exception => e
      errors << "error occured while sharing schloopmark with parents"
    end
  end
  private
  def followup_params
    params.permit.(:bookmark_id)
  end

end
