# == Schema Information
#
# Table name: parent_details
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  school_id   :integer
#  first_name  :string
#  last_name   :string
#  middle_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe ParentDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
