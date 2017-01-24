# == Schema Information
#
# Table name: subjects
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  subject_code      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  grade_id          :integer
#  master_subject_id :integer          default(0), not null
#
# Indexes
#
#  index_subjects_on_grade_id  (grade_id)
#
# Foreign Keys
#
#  fk_rails_33d539df11  (grade_id => grades.id)
#

class Subject < ActiveRecord::Base
  belongs_to :grade
  belongs_to :master_subject

  has_many :bookmarks, dependent: :destroy

  def destroy_data
    # 1. destroy grade_teacher data
    # 2. destroy bookmarks

  end
end
