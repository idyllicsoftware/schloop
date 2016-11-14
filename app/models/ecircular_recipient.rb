# == Schema Information
#
# Table name: ecircular_recipients
#
#  id          :integer          not null, primary key
#  school_id   :integer
#  grade_id    :integer
#  division_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EcircularRecipient < ActiveRecord::Base
end
