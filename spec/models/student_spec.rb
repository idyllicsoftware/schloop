# == Schema Information
#
# Table name: students
#
#  id                :integer          not null, primary key
#  school_id         :integer
#  first_name        :string
#  last_name         :string
#  middle_name       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  activation_status :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Student, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
