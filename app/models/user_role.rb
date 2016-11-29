# == Schema Information
#
# Table name: user_roles
#
#  id               :integer          not null, primary key
#  user_original_id :integer
#  role_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Foreign Keys
#
#  fk_rails_3369e0d5fc  (role_id => roles.id)
#

class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
