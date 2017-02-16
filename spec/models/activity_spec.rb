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
  before(:each) do
    FactoryGirl.create(:role,:teacher)
    FactoryGirl.create(:role,:parent)
    @master_subject1 = FactoryGirl.create(:master_subject, :Arts)
    @master_subject2 = FactoryGirl.create(:master_subject, :Algebra)
    @master_grade = FactoryGirl.create(:master_grade, :Playgroup)
    @activity1 = Activity.create!({teaches:"Thinking & also Listening", 
      topic:"Early Vocabulary", 
      title:"Before the Alphabet: Speak, Speak, Speak & listen", 
      master_grade_id: @master_grade.id, 
      master_subject_id: @master_subject1.id, 
      details:"1. Speak with kids as an individual and not as a child.", 
      pre_requisite: "None", 
      status: "active"})
    @activity2 = Activity.create!({teaches:"Object & Color Recognition", 
      topic:"Colors", 
      title:"What's My Color?", 
      master_grade_id: @master_grade.id, 
      master_subject_id: @master_subject2.id, 
      details:"• Parents need to play a puzzle game by asking simple questions to kids.", 
      status: 0})
    ActivityShare.create!({ activity_id: @activity1.id,
      school_id:1, 
      teacher_id:20, 
      grade_id:3, 
      division_id:6, 
    })
    ActivityShare.create!({activity_id: @activity2.id, 
      school_id:1, 
      teacher_id:21, 
      grade_id:13, 
      division_id:20, 
    })
   # @teacher = instance_double("Teacher", id:151, 
   #   email:"supriya+1@idyllic.co", 
   #   school_id:32, 
   #   first_name:"Sups", 
   #   middle_name:nil, 
   #   last_name:"..", 
   #   cell_number:"5656545412")
    @teacher = FactoryGirl.create(:teacher)
    #@parent = instance_double("Parent",id:401, 
    #  email:"supriya+01@idyllic.co", 
    #  first_name:"supriya", 
    #  middle_name:nil, 
    #  last_name:"M", 
    #  work_number:nil, 
    #  cell_number:"4555545127", 
    #  school_id:32)
    @parent = FactoryGirl.create(:parent)
    @activity_ids = Activity.ids
  end
  it "check that activities to be returned are sorted in reverse order of created_at of activity_shares" do 
    records,count = Activity.grade_activities({id: @activity_ids},nil,nil,nil,@parent)
    for i in 0..(count-2)
      current_activity = Activity.find_by(id: records[i][:activity][:id]).activity_shares.first
      next_activity = Activity.find_by(id: records[i+1][:activity][:id]).activity_shares.first
      expect(current_activity.created_at).to be >= next_activity.created_at
    end
  end
  it "check that activities to be returned are sorted in reverse order of created_at of activity" do
    records,count = Activity.grade_activities({id:@activity_ids},nil,nil,nil,@teacher)
    for i in 0..(count-2)
      current_activity = Activity.find_by(id: records[i][:activity][:id])
      next_activity = Activity.find_by(id: records[i+1][:activity][:id])
      expect(current_activity.created_at).to be >= next_activity.created_at
    end
  end
end