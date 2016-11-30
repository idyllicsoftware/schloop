# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  name       :string
#  controller :string
#  action     :string
#  flags      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Permission < ActiveRecord::Base

	has_many :role_permissions, dependent: :destroy
	has_many :roles, through: :role_permissions
	
end
