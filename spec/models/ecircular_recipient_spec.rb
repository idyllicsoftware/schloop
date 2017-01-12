# == Schema Information
#
# Table name: ecircular_recipients
#
#  id           :integer          not null, primary key
#  school_id    :integer
#  grade_id     :integer
#  division_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ecircular_id :integer
#
# Indexes
#
#  index_ecircular_recipients_on_ecircular_id  (ecircular_id)
#
# Foreign Keys
#
#  fk_rails_6ed422b045  (ecircular_id => ecirculars.id)
#

require 'rails_helper'

RSpec.describe EcircularRecipient, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
