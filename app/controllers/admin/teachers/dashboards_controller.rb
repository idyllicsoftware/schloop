class Admin::Teachers::DashboardsController < ApplicationController

	layout "teacher"
	
  def show
    subject_id = Subject.select('master_subject_id').where(id: params[:subject_id] )
    grade_id = Grade.select('master_grade_id').where(id: params[:grade_id] )

    @topics = Topic.where(teacher_id: [params[:id],-1]).where(master_grade_id: grade_id).where(masater_subject_id: subject_id)
    @bookmarsk = Bookmark.where(teacher_id: params[:id]).where(grade_id: grade_id.master_grade_id).where(subject_id: subject_id.master_subject_id)
  end
end