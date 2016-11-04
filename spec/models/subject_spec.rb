# == Schema Information
#
# Table name: subjects
#
#  id           :integer          not null, primary key
#  name         :string
#  subject_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Subject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
