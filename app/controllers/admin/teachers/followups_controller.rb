class Admin::Teachers::FollowupsController < ApplicationController

  def create
    errors = []
    data = {}
    begin
      bookmark = Bookmark.find_by(id: followup_params[:bookmark_id]) 
      raise CustomError, "bookmark not found" if bookmark.blank?
      grade = bookmark.grade
      student_ids = StudentProfile.where(grade_id: grade.id).pluck(:student_id)
      parent_ids = Student.where(id: student_ids).pluck(:parent_id).uniq
      first_parent = Parent.find_by(id: parent_ids.first)
      new_followup = Followup.create(bookmark_id: params[:bookmark_id])
      data = { parent_first_name: first_parent.name, count: parent_ids.count}
    rescue Exception => e
      errors << "error occured while sharing schloopmark with parents"
      errors << ","+ e.message
    end
    render json: { success: errors.blank?, errors: errors, data: data}
  end
  private
  def followup_params
    params.permit(:bookmark_id)
  end

end
