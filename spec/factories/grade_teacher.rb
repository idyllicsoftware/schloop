FactoryGirl.define do
  factory :grade_teacher do
    association :division, factory: :division
    association :subject, factory: :subject
    association :teacher, factory: :teacher
    association :grade, factory: :grade
  end
end
