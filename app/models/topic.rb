# == Schema Information
#
# Table name: topics
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  master_grade_id   :integer
#  master_subject_id :integer
#  teacher_id        :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_topics_on_master_grade_id_and_master_subject_id  (master_grade_id,master_subject_id)
#  index_topics_on_teacher_id                             (teacher_id)
#

class Topic < ActiveRecord::Base
  belongs_to :master_grade
  belongs_to :master_subject
  belongs_to :teacher 
end
