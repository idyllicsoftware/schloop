# == Schema Information
#
# Table name: followups
#
#  id          :integer          not null, primary key
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_followups_on_bookmark_id  (bookmark_id)
#
# Foreign Keys
#
#  fk_rails_ea7649d296  (bookmark_id => bookmarks.id)
#

require 'rails_helper'
require 'pry'
RSpec.describe Followup, type: :model do
  before(:each) do
    @role = FactoryGirl.create(:role,:teacher)
    @school = FactoryGirl.create(:school)
    @role = FactoryGirl.create(:role,:parent)
    @parent = FactoryGirl.create(:parent)
    @master_grade = FactoryGirl.create(:master_grade, :"1st Grade")
    #@student = FactoryGirl.create(:student)
    @student = Student.create(school_id: @school.id, first_name: "student_1", last_name: "M", parent_id: @parent.id, activation_status: true)
    @teacher = FactoryGirl.create(:teacher)
    @grade = FactoryGirl.create(:grade)
    @student_profiles = StudentProfile.create!(student_id:@student.id, grade_id:@grade.id, division_id:171, status: 0)
  end
  it "should return result order in reverse of time of sharing to parents" do
    records = Followup.index_for_web(Student.last)
    count = records.count
    for i in 0..(count-2)
      current_activity = Bookmark.find_by(id: records[i][:activity][:id]).activity_shares.first
      next_activity = Bookmark.find_by(id: records[i+1][:activity][:id]).activity_shares.first
      expect(current_activity.created_at).to be >= next_activity.created_at
    end  
  end
end
