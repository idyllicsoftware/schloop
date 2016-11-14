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
#

class Ecircular < ActiveRecord::Base
	#has_many: attachments
	has_many :receipients
	enum circular_type: [:lesson_plan , :exam_timetable, :my_result, :my_attendance, :class_timetable, :sample_papers ] 

 	enum created_by_type: [ :teacher, :school_admin, :product_admin]



end
