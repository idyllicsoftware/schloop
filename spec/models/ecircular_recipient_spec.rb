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

require 'rails_helper'

RSpec.describe EcircularRecipient, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
