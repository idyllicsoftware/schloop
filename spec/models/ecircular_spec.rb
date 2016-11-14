# == Schema Information
#
# Table name: ecirculars
#
#  id              :integer          not null, primary key
#  title           :string
#  body            :text
#  circular_type   :integer
#  created_by_type :integer
#  created_by_id   :integer
#

require 'rails_helper'

RSpec.describe Ecircular, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
