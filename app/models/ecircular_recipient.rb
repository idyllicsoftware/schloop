# == Schema Information
#
# Table name: ecircular_recipients
#
#  id           :integer          not null, primary key
#  school_id    :integer
#  grade_id     :integer
#  division_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ecircular_id :integer
#
# Indexes
#
#  index_ecircular_recipients_on_ecircular_id  (ecircular_id)
#
# Foreign Keys
#
#  fk_rails_6ed422b045  (ecircular_id => ecirculars.id)
#

class EcircularRecipient < ActiveRecord::Base
	belongs_to :ecircular
end
