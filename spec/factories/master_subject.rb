FactoryGirl.define do
  factory :master_subject do
    master_subjects = ['Algebra', 'Arts', 'Biology', 'Chemistry', 'Civics', 'Drawing', 'English', 'General Knowledge', 'Geography', 'Geometry', 'Hindi', 'History', 'Marathi', 'Mathematics', 'Physics', 'Science', 'Social Science', 'Computer Science', 'Life Skills']
    master_subjects.each do |subject|
      trait subject.to_sym do
        name subject
        name_map subject.downcase
      end
    end
    trait 'Arts'.to_sym do
      name 'Arts'
      name_map 'Arts'.downcase
    end
  end
end
