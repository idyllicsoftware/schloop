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

  it "check that activities to be returned are sorted in reverse order or created_at" do |variable|
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
    records,count = Activity.grade_activities({:id=>[]},nil,nil,nil)
    for i in 0..(count-2)
      current_activity = Activity.find_by(id: records[i][:activity][:id])
      next_activity = Activity.find_by(id: records[i+1][:activity][:id])
      expect(current_activity.created_at).to be >= next_activity.created_at
    end
  end

end