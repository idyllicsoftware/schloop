# == Schema Information
#
# Table name: activities
#
#  id                :integer          not null, primary key
#  teaches           :string
#  topic             :string           not null
#  title             :string           not null
#  master_grade_id   :integer          not null
#  master_subject_id :integer          not null
#  details           :text
#  pre_requisite     :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe Activity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
