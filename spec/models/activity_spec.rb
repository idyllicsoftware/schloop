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
    MasterSubject.create!(
      {id:7, name:"English", 
      name_map: "english", 
      created_at:"Fri, 25 Nov 2016 15:12:38 IST +05:30",
      updated_at:"Fri, 25 Nov 2016 15:12:38 IST +05:30"})
    MasterSubject.create!({
      id: 8, name: "General Knowledge", 
      name_map: "general_knowledge", 
      created_at: "Fri, 25 Nov 2016 15:12:38 IST +05:30", 
      updated_at: "Fri, 25 Nov 2016 15:12:38 IST +05:30"} )
    MasterGrade.create!(
      {id: 1, name: "Playgroup", 
      name_map: "playgroup", 
      created_at: "Fri, 25 Nov 2016 15:12:38 IST +05:30", 
      updated_at: "Fri, 25 Nov 2016 15:12:38 IST +05:30"} )
    Activity.create!({id:1, teaches:"Thinking & Listening", 
      topic:"Early Vocabulary", 
      title:"Before the Alphabet: Speak, Speak, Speak & listen", 
      master_grade_id: 1, 
      master_subject_id: 7, 
      details:"1. Speak with kids as an individual and not as a child.", 
      pre_requisite: "None", 
      created_at: "Tue, 27 Dec 2016 23:07:06 IST +05:30", 
      updated_at: "Tue, 27 Dec 2016 23:07:06 IST +05:30", 
      status: "active"})
    Activity.create!({id:5, teaches:"Object & Color Recognition", 
      topic:"Colors", 
      title:"What's My Color?", 
      master_grade_id:1, 
      master_subject_id: 8, 
      details:"• Parents need to play a puzzle game by asking simple questions to kids.", 
      created_at:"Wed, 11 Jan 2017 14:26:11 IST +05:30", 
      updated_at:"Wed, 11 Jan 2017 14:26:11 IST +05:30", 
      status: 0})
    ActivityShare.create!({
      id:35, activity_id:1,
      school_id:1, 
      teacher_id:20, 
      grade_id:3, 
      division_id:6, 
      created_at:"Wed, 01 Feb 2017 21:20:19 IST +05:30",
      updated_at:"Wed, 01 Feb 2017 21:20:19 IST +05:30"})
    ActivityShare.create!({
      id:26, activity_id:5, 
      school_id:1, 
      teacher_id:21, 
      grade_id:13, 
      division_id:20, 
      created_at:"Wed, 01 Feb 2017 20:25:50 IST +05:30", 
      updated_at:"Wed, 01 Feb 2017 20:25:50 IST +05:30"})
    @teacher = instance_double("Teacher", id:151, 
      email:"supriya+1@idyllic.co", 
      school_id:32, 
      first_name:"Sups", 
      middle_name:nil, 
      last_name:"..", 
      cell_number:"5656545412")
    @parent = instance_double("Parent",id:401, 
      email:"supriya+01@idyllic.co", 
      first_name:"supriya", 
      middle_name:nil, 
      last_name:"M", 
      work_number:nil, 
      cell_number:"4555545127", 
      school_id:32)
  end
  it "check that activities to be returned are sorted in reverse order of created_at of activity_shares" do 
    records,count = Activity.grade_activities({:id=>[]},nil,nil,nil,@parent)
    for i in 0..(count-2)
      current_activity = Activity.find_by(id: records[i][:activity][:id]).activity_shares.first
      next_activity = Activity.find_by(id: records[i+1][:activity][:id]).activity_shares.first
      expect(current_activity.created_at).to be >= next_activity.created_at
    end
  end
  it "check that activities to be returned are sorted in reverse order of created_at of activity" do
    records,count = Activity.grade_activities({:id=>[]},nil,nil,nil,@teacher)
    for i in 0..(count-2)
      current_activity = Activity.find_by(id: records[i][:activity][:id])
      next_activity = Activity.find_by(id: records[i+1][:activity][:id])
      expect(current_activity.created_at).to be >= next_activity.created_at
    end
  end
end