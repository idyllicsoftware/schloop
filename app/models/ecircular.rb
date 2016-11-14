class Ecircular < ActiveRecord::Base
	#has_many: attachments
	has_many: receipients
	enum circular_type: [ :lesson_plan  :exam_time_table, :my_result, :my_attendance, :class_timetable, :sample_papers, 
	 	:transport_details, :holiday_circular, :Medical_visit_report,:News_and_Events,:Important_Announcement,:Event_Circular, 
	 	:Awards_and_Achievements,:Fee_Notice,:Follow_up_activity_for_Parents,:Exhibitions,:Worksheets,
	 	:Extra_Curricular_Activities_Circular,:School_Time_Change,:Inter_School_Competitions,:Intra_School_Competitions,:Olympiads ]

 	enum created_by_type: [:teacher, :school_admin, :product_admin]



end
