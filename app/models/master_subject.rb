# == Schema Information
#
# Table name: master_subjects
#
#  id         :integer          not null, primary key
#  name       :string
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_master_subjects_on_name_map  (name_map)
#

class MasterSubject < ActiveRecord::Base
end
