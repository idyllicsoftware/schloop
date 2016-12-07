class GradeTeachersDataService < BaseService

  def get_grade_teacher_data(teacher_id)
    grade_teacher_data = []
    teacher = Teacher.find(teacher_id)
    grades_data = teacher.grade_teachers.group_by do |x| x.grade_id end

    grades_data.each do |grade_id, datas|
      subjects_data = {}
      datas.each do |data|
        subjects_data[data.subject_id ] ||= {
          subject_id: data.subject_id,
          subject_name: data.subject.name,
          divisions_data: []
        }

        subjects_data[data.subject_id][:divisions_data] << {
          division_id: data.division_id,
          division_name: data.division.name
        }
      end
      grade_teacher_data << {
        grade_id: grade_id,
        grade_name: datas.first.grade.name,
        subjects_data: subjects_data.values
      }
    end
    return grade_teacher_data
  end
end