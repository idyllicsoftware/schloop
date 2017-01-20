class Admin::Teachers::DashboardsController < ApplicationController
	layout "teacher"
  def index
    @grade_teacher_data = []
    @teacher = current_teacher
    grades_data = @teacher.grade_teachers.includes(:grade).includes(:subject).group_by do |record| record.grade_id end

    grades_data.each do |grade_id, datas|
      subjects_data = {}
      datas.each do |data|
        subjects_data[data.subject_id ] ||= {
          subject_id: data.subject_id,
          subject_name: data.subject.name
        }
      end
      @grade_teacher_data << {
        grade_id: grade_id,
        grade_name: datas.first.grade.name,
        subjects_data: subjects_data.values
      }
    end
  end
end
