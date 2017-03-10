# == Schema Information
#
# Table name: collaborations
#
#  id                    :integer          not null, primary key
#  bookmark_id           :integer
#  collaboration_message :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_collaborations_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_002aed23cd  (bookmark_id => bookmarks.id)
#

require 'rails_helper'

RSpec.describe Collaboration, type: :model do
  before(:each) do
    @teacher = FactoryGirl.create(:teacher)
    subject = FactoryGirl.create(:subject)
    grade = FactoryGirl.create(:grade)
    10.times do
      bookmark = FactoryGirl.create(:bookmark, grade_id: grade.id, subject_id: subject.id)
      FactoryGirl.create(:collaboration, bookmark_id: bookmark.id)
    end
    FactoryGirl.create(:grade_teacher, teacher_id: @teacher.id, grade_id: grade.id, subject_id: subject.id)
  end
  describe '#index' do
    it 'return empty array and 0' do
      _records, count = Collaboration.index(@teacher)
      expect(count).to eq 10
    end
  end
end
