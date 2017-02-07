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

  # it "is not valid without a topic" do
  #   activity = Activity.new(topic: nil)
  #   expect(activity).to_not be_valid
  # end


  # context "When testing activity creation" do
  #   it "It must create a valid activity" do
  #     activity_params = {
  #       teaches: "teaches value",
  #       topic: "test topic",
  #       title: "test title",
  #       master_grade: MasterGrade.first,
  #       master_subject: MasterSubject.first,
  #       details: "test details",
  #       pre_requisite: "test pre_requisite"
  #     }
  #     activity = Activity.create(activity_params)
  #     expect(activity.topic).to eq "test topic"
  #   end
  # end

end