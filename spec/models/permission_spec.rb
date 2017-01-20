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

require 'rails_helper'

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
