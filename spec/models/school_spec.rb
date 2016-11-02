# == Schema Information
#
# Table name: schools
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  address            :text             not null
#  zip_code           :string           not null
#  phone1             :string           not null
#  phone2             :string
#  website            :string           not null
#  school_director_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  code               :string           not null
#  board              :string
#

require 'rails_helper'

RSpec.describe School, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
