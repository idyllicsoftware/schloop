# == Schema Information
#
# Table name: ecirculars
#
#  id              :integer          not null, primary key
#  title           :string
#  body            :text
#  circular_type   :integer
#  created_by_type :integer
#  created_by_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#

class Ecircular < ActiveRecord::Base
	has_many :attachments

	enum circular_type: {lesson_plan: 0, exam_time_table: 1, my_result: 2, my_attendance: 3, class_timetable: 4, sample_papers: 5,
											 transport_details: 6, holiday_circular: 7, medical_visit_report: 8, news_and_events: 9, important_announcement: 10,
											 event_circular: 11, awards_and_achievements: 12, fee_notice: 13, follow_up_activity_for_parents: 14,
											 exhibitions: 15, worksheets: 16, extra_curricular_activities_circular: 17, school_time_change: 18,
											 inter_school_competitions: 19, intra_school_competitions: 20, olympiads: 21 }

 	enum created_by_type: {teacher: 0, school_admin: 1, product_admin: 2}

 	belongs_to :school
	has_many :ecircular_recipients
end
