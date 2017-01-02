# == Schema Information
#
# Table name: ecirculars
#
#  id              :integer          not null, primary key
#  title           :string
#  body            :text
#  circular_tag    :integer
#  created_by_type :integer
#  created_by_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#

class Ecircular < ActiveRecord::Base
	#enum circular_tag: {lesson_plan: 0, exam_time_table: 1, my_result: 2, my_attendance: 3, #class_timetable: 4, sample_papers: 5,
	#										 transport_details: 6, holiday_circular: 7, medical_visit_report: 8, #news_and_events: 9, important_announcement: 10,
	#										 event_circular: 11, awards_and_achievements: 12, fee_notice: 13, #follow_up_activity_for_parents: 14,
	#										 exhibitions: 15, worksheets: 16, extra_curricular_activities_circular: 17, #school_time_change: 18,
	#										 inter_school_competitions: 19, intra_school_competitions: 20, olympiads: #21 }
  enum circular_tag: { circular: 0, assignment: 1, lesson_plan: 2, from_notice_board: 3,
											 teachers_message: 4, year_plan: 5, time_table: 6, attendance: 7, holiday: 8,
											 health_report: 9 }
 	enum created_by_type: { teacher: 0, school_admin: 1, product_admin: 2 }

  belongs_to :school
  has_many :attachments, as: :attachable
  has_many :ecircular_recipients
	has_many :ecircular_parents
	has_many :ecircular_teachers

  # after_create :send_notification

  validates :title, :created_by_type, :created_by_id , :presence => true

	def self.school_circulars(school, user, filter_params={}, offset=0, page_size=50)
		circular_data = []
		circulars = school.ecirculars
		filter_circular_ids = filter_params[:id]
		circulars = circulars.where(id: filter_circular_ids)

		if filter_params[:from_date].present?
			from_date = DateTime.parse(filter_params[:from_date])
			circulars = circulars.where("ecirculars.created_at >= ?", from_date.beginning_of_day)
		end

		if filter_params[:to_date].present?
			to_date = DateTime.parse(filter_params[:to_date])
			circulars = circulars.where("ecirculars.created_at <= ?", to_date.end_of_day)
		end

		if filter_params[:tags].present?
			circulars = circulars.where(circular_tag: filter_params[:tags])
		end

		total_records = circulars.count
		circulars = circulars.includes(:attachments, ecircular_recipients: [:grade, :division]).order(id: :desc).offset(offset).limit(page_size)

		circular_parents_by_ecircular_id = EcircularParent.where(ecircular_id: circulars.ids).group_by{|x| x.ecircular_id}
		circular_teachers_by_ecircular_id = EcircularTeacher.where(ecircular_id: circulars.ids).group_by{|x| x.ecircular_id}

    circular_tracker_data_by_ecircular_id = Tracker.where(trackable_id: circulars.ids,
                                                          trackable_type: "Ecircular",
                                                          user_id: user.id,
                                                          user_type: user.class.name).index_by(&:trackable_id)
		circulars.each do |circular|
			circular_data << circular.data_for_circular(circular_parents_by_ecircular_id, circular_teachers_by_ecircular_id, circular_tracker_data_by_ecircular_id)
		end
		return circular_data, total_records
	end

	def data_for_circular(circular_parents_by_ecircular_id, circular_teachers_by_ecircular_id, circular_tracker_data_by_ecircular_id = {})
		recipients, attachments, students_data, teachers_data = [], [], [], []
		grouped_circulars = self.ecircular_recipients.group_by do |x| x.grade_id end
		grades_by_id = Grade.where(id: grouped_circulars.keys).index_by(&:id)
		grouped_circulars.each do |grade_id, recipients_data|
			recipient = {grade_id: grade_id, grade_name: (grades_by_id[grade_id].name rescue "-")}
			recipient[:divisions] = []
			recipients_data.each do |rec|
				recipient[:divisions] << {div_id: rec.division_id, div_name: (rec.division.name rescue "-")}
			end
			recipients << recipient
		end

		self.attachments.select(:id, :original_filename, :name).each do |attachment|
			attachments << {original_filename: attachment.original_filename, s3_url: attachment.name}
		end
		created_by = (created_by_type || 'teacher').classify.safe_constantize.find_by(id: created_by_id)
		student_ids = circular_parents_by_ecircular_id[id].collect(&:student_id) rescue []
		students = Student.active.where(id: student_ids).includes(student_profiles: [:grade, :division]) || []

		students.each do |student|
			students_data << {
					id: student.id,
					name: student.name,
					grade: {
							id: (student.student_profiles.last.grade.id rescue 0),
							name: (student.student_profiles.last.grade.name rescue '')
					},
					division: {
							id: (student.student_profiles.last.division.id rescue 0),
							name: (student.student_profiles.last.division.name rescue '')
					}
			}
		end

		teacher_ids = circular_teachers_by_ecircular_id[id].collect(&:teacher_id) rescue []
		teachers = Teacher.where(id: teacher_ids) || []

		teachers.each do |teacher|
			teachers_data << {
					id: teacher.id,
					first_name: teacher.first_name,
					last_name: teacher.last_name
			}
		end


		return {
				id: id,
				title: title,
				body: body,
        is_read: circular_tracker_data_by_ecircular_id[id].present?,
				created_by: {
						id: (created_by.id rescue 0),
						name: (created_by.name rescue '-')
				},
				created_on: created_at,
				circular_tag: {
						id: Ecircular.circular_tags[circular_tag],
						name: circular_tag.present? ? circular_tag.humanize : ''
				},
				recipients: recipients,
				students: students_data,
				teachers: teachers_data,
				attachments: attachments
		}
	end

	def send_notification(student_ids)
		student_ids.each do |student_id|
			NotificationWorker.perform_async(self.id, student_id)
		end
	end
end
