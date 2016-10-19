# == Schema Information
#
# Table name: user_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_roles_on_user_id              (user_id)
#  index_user_roles_on_user_id_and_role_id  (user_id,role_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_318345354e  (user_id => users.id)
#  fk_rails_3369e0d5fc  (role_id => roles.id)
#

class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
