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
#

class Ecircular < ActiveRecord::Base
	#has_many: attachments
	has_many :receipients
	enum circular_type: [ :lesson_plan ,:exam_time_table, :my_result, :my_attendance, :class_timetable, :sample_papers, 
	 	:transport_details, :holiday_circular, :medical_visit_report,:news_and_events,:important_announcement,:event_circular, 
	 	:awards_and_achievements,:fee_notice,:follow_up_activity_for_parents,:exhibitions,:worksheets,
	 	:extra_curricular_activities_circular,:school_time_change,:inter_school_competitions,:intra_school_competitions,:olympiads ]

 	enum created_by_type: [ :teacher, :school_admin, :product_admin]

end
