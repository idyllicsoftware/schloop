# == Schema Information
#
# Table name: grades
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#  master_grade_id :integer          default(0), not null
#
# Indexes
#
#  index_grades_on_school_id  (school_id)
#
# Foreign Keys
#
#  fk_rails_9803afc4f6  (school_id => schools.id)
#

class Grade < ActiveRecord::Base
	belongs_to :school
	belongs_to :master_grade
	has_many :divisions, dependent: :destroy
	has_many :subjects, dependent: :destroy
  has_many :student_profiles, dependent: :destroy
	has_many :ecircular_recipients, dependent: :destroy
  has_many :activity_shares, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

	validates :name, :presence => true

  def self.create_grade(school, grades_data)
    errors = []
    begin
      ActiveRecord::Base.transaction do
        is_valid_grade_data = Grade.where(school_id: school.id).where("name = ? OR master_grade_id = ?",grades_data[:grade_name], grades_data[:master_grade_id])
        raise "Grade already exist or name already used for other grade" if is_valid_grade_data.present?
        grade = school.grades.create(name: grades_data[:grade_name], master_grade_id: grades_data[:master_grade_id])
        master_subjects_by_id = MasterSubject.where(id: grades_data[:master_subject_ids]).index_by(&:id)
        grades_data[:master_subject_ids].each do |master_subject_id|
          master_subject = master_subjects_by_id[master_subject_id.to_i]
          grade.subjects.create(name: master_subject.name, master_subject_id: master_subject_id)
        end
      end
    rescue => ex
      errors << ex.message
      Rails.logger.debug("Exception in creating grade: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
    end
    { success: errors.blank?, errors: errors, grade_name: grades_data[:grade_name] }
  end

  def destroy_grade
    errors = []
    begin
      destroy
    rescue => ex
      errors << 'Something went wrong. Please contact to support team.'
      Rails.logger.debug("Exception in destroying grade: Message: #{ex.message}/n/n/n/n Backtrace: #{ex.backtrace}")
    end
    { success: errors.blank?, errors: errors }
  end
end