# == Schema Information
#
# Table name: activity_categories
#
#  id          :integer          not null, primary key
#  activity_id :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe ActivityCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
