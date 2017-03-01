# == Schema Information
#
# Table name: bookmarks
#
#  id                :integer          not null, primary key
#  title             :string
#  data              :text
#  caption           :text
#  url               :string
#  preview_image_url :string
#  likes             :integer          default(0), not null
#  views             :integer          default(0), not null
#  topic_id          :integer
#  data_type         :integer          default(0), not null
#  school_id         :integer
#  grade_id          :integer
#  subject_id        :integer
#  teacher_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_bookmarks_on_grade_id_and_subject_id  (grade_id,subject_id)
#  index_bookmarks_on_school_id                (school_id)
#  index_bookmarks_on_teacher_id               (teacher_id)
#

require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:teacher) { FactoryGirl.create(:teacher, email: 'dmuktesh01@gmail.com') }
  let(:grade) { FactoryGirl.create(:grade) }
  let(:subject) { FactoryGirl.create(:subject, grade_id: grade.id) }
  let(:topic) { FactoryGirl.create(:topic, master_grade_id: grade.master_grade_id, master_subject_id: subject.master_subject_id) }
  before(:each) do
        10.times do
      FactoryGirl.create(:bookmark, grade_id: grade.id, subject_id: subject.id, topic_id: topic.id, teacher_id: teacher.id)
    end
  end
  describe '#self.index' do
    it 'expect that teacher is passed as argument' do
      expect(Bookmark.index(teacher, grade.id, subject.id, topic.id).count).to eq 10
    end
  end
  describe '#formatted_data' do
    it 'validates that data element returned by formatted_data contian alll keys' do
      bookmark = Bookmark.first
      builded_data = bookmark.formatted_data
      expect(builded_data).to include(:id, :title, :caption, :data, :type, :subject_id, :subject_name, :grade_id, :grade_name, :url, :preview_image_url, :likes, :views, :created_at, :topic, :teacher)
      expect(builded_data[:topic]).to include(:topic_id, :topic_title)
      expect(builded_data[:teacher]).to include(:id, :first_name, :last_name)
    end
  end
end
