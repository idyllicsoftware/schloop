# == Schema Information
#
# Table name: user_roles
#
#  id          :integer          not null, primary key
#  role_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entity_type :string
#  entity_id   :integer
#
# Foreign Keys
#
#  fk_rails_3369e0d5fc  (role_id => roles.id)
#

require 'rails_helper'

RSpec.describe UserRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
