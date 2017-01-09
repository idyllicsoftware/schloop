# == Schema Information
#
# Table name: role_permissions
#
#  id            :integer          not null, primary key
#  role_id       :integer
#  permission_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_role_permissions_on_permission_id  (permission_id)
#  index_role_permissions_on_role_id        (role_id)
#
# Foreign Keys
#
#  fk_rails_439e640a3f  (permission_id => permissions.id)
#  fk_rails_60126080bd  (role_id => roles.id)
#

require 'rails_helper'

RSpec.describe RolePermission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
