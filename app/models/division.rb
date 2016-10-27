# == Schema Information
#
# Table name: divisions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Division < ActiveRecord::Base
	belongs_to :grade
end
