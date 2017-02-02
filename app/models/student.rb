# == Schema Information
#
# Table name: students
#
#  id                :integer          not null, primary key
#  school_id         :integer
#  first_name        :string
#  last_name         :string
#  middle_name       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  activation_status :boolean          default(TRUE)
#

class Student < ActiveRecord::Base
	belongs_to :school
	belongs_to :parent
	has_many :student_profiles, :dependent => :destroy
	validates :first_name, :presence => true, :length => { :maximum => 30 }
	validates :middle_name,  :length => { :maximum => 30 }
	validates :last_name, :presence => true, :length => { :maximum => 30 }
	scope :active, -> { where(activation_status: true)}

	validate do |student|
		student.student_profiles.each do |student|
			next if student.valid?
			student.errors.full_messages.each do |message|
				# you can customize the error message here:
				errors.add :base, "#{message}"
			end
		end
	end

	def name
		"#{self.first_name} #{self.middle_name} #{self.last_name}"
	end

end
