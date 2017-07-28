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
  describe '#grade_activities' do
    before(:each) do
      MasterSubject.create!(
        name: 'English',
        name_map: 'english'
      )
      MasterSubject.create!(name: 'General Knowledge',
                            name_map: 'general_knowledge')
      MasterGrade.create!(
        name: 'Playgroup',
        name_map: 'playgroup'
      )
      activity_one = FactoryGirl.create(:activity)
      activity_two = FactoryGirl.create(:activity)

      #       Activity.create!({teaches:"Thinking & Listening",
      #         topic:"Early Vocabulary",
      #         title:"Before the Alphabet: Speak, Speak, Speak & listen",
      #         master_grade_id: 1,
      #         master_subject_id: 7,
      #         details:"1. Speak with kids as an individual and not as a child.",
      #         pre_requisite: "None",
      #         status: "active"})
      #       Activity.create!({ teaches:"Object & Color Recognition",
      #         topic:"Colors",
      #         title:"What's My Color?",
      #         master_grade_id:1,
      #         master_subject_id: 8,
      #         details:"• Parents need to play a puzzle game by asking simple questions to kids.",
      #         status: 0})
      ActivityShare.create!(id: 35, activity_id: activity_one.id,
                            school_id: 1,
                            teacher_id: 20,
                            grade_id: 3,
                            division_id: 6)
      ActivityShare.create!(id: 26, activity_id: activity_two.id,
                            school_id: 1,
                            teacher_id: 21,
                            grade_id: 13,
                            division_id: 20)
      @teacher = instance_double('Teacher', id: 151,
                                            email: 'supriya+1@idyllic.co',
                                            school_id: 32,
                                            first_name: 'Sups',
                                            middle_name: nil,
                                            last_name: '..',
                                            cell_number: '5656545412')
      @parent = instance_double('Parent', id: 401,
                                          email: 'supriya+01@idyllic.co',
                                          first_name: 'supriya',
                                          middle_name: nil,
                                          last_name: 'M',
                                          work_number: nil,
                                          cell_number: '4555545127',
                                          school_id: 32)
    end
    it 'check that activities to be returned are sorted in reverse order of created_at of activity_shares' do
      records, count = Activity.grade_activities({ id: [] }, nil, nil, nil, @parent)
      for i in 0..(count - 2)
        current_activity = Activity.find_by(id: records[i][:activity][:id]).activity_shares.first
        next_activity = Activity.find_by(id: records[i + 1][:activity][:id]).activity_shares.first
        expect(current_activity.created_at).to be >= next_activity.created_at
      end
    end
    it 'check that activities to be returned are sorted in reverse order of created_at of activity' do
      records, count = Activity.grade_activities({ id: [] }, nil, nil, nil, @teacher)
      for i in 0..(count - 2)
        current_activity = Activity.find_by(id: records[i][:activity][:id])
        next_activity = Activity.find_by(id: records[i + 1][:activity][:id])
        expect(current_activity.created_at).to be >= next_activity.created_at
      end
    end
  end
  describe '#send_notification' do
    it 'check notification are enequed', send: true do
      stats = Sidekiq::Stats.new
      past_job_count = stats.processed + stats.enqueued + stats.failed

      school = School.create(name: 'Loyla', address: 'pune', zip_code: '400103', phone1: '07588584810', phone2: '07588584810', website: 'www.loyla.com', code: 'LO0001', board: nil, principal_name: nil)
      grade = Grade.create(name: 'Grade I', school_id: school.id, master_grade_id: 1)
      subject = Subject.create(name: 'Physics', grade_id: grade.id, master_subject_id: 4)
      division = Division.create(name: 'B', grade_id: grade.id)
      teacher = Teacher.create(email: 'muktesh@idyllic.co', school_id: 32, token: 'a032a0af6bf94aaeb8f71fbf210648b3', first_name: 'Sups', middle_name: nil, last_name: '..', cell_number: '5656545412')
      GradeTeacher.create(division_id: division.id, subject_id: subject.id, teacher_id: teacher.id, grade_id: grade.id)
      Device.create(deviceable_id: teacher.id, deviceable_type: 'Teacher', device_type: 0, token: 'cweaRmtfHJ4:APA91bFZFwtwVX1Jns1XBDBSS24QxGydoHr7fS...', os_version: '', status: 0)
      Activity.create(teaches: 'Shapes Identification & reasoning ', topic: 'Shapes', title: '2D shape Flashcards', master_grade_id: 1, master_subject_id: 4, details: '- Introduce the shape with a flashcard. (Introduce...', pre_requisite: 'Shape flashcards, paper, pencil, crayons/sand, glu...')
      sleep 5.0
      stats = Sidekiq::Stats.new
      present_job_count = stats.processed + stats.enqueued + stats.failed
      expect(past_job_count).to be < present_job_count
    end
  end
end
