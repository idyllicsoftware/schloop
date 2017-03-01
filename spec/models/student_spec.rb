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
  before(:each) do
    @parent = FactoryGirl.create(:parent)
    @student = FactoryGirl.create(:student, parent_id: @parent.id)
  end
  it 'should deactivate associated parent' do
    @student.activation_status = false
    @student.save
    expect(@student.parent.activation_status).to be false
  end
end
