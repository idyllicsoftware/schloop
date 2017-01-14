class Admin::Teachers::FollowupsController < ApplicationController

  def create
    errors, data = [], {}
    begin
      bookmark = Bookmark.find_by(id: followup_params[:bookmark_id])
      grade = bookmark.grade
      student_ids = StudentProfile.where(grade_id: grade.id).where(status: 'active').pluck(:student_id)
      parent_ids = Student.pluck(:parent_id).where(id: student_ids)
      first_parent = Parent.find_by(id: parent_ids.first)
      data = {parent_name: first_parent.name, count: parent_ids.count}
    rescue Exception => e
      errors << "error occured while sharing schloopmark with parents" + ', ' + e.message
    end
    render json: {success: errors.blank?, errors: errors,  data: data}
  end

  private
  def followup_params
    params.permit(:bookmark_id)
  end

end
