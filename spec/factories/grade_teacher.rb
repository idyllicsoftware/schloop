FactoryGirl.define do
  factory :grade_teacher do
    association :division, factory: :division
    association :grade, factory: :grade
    association :subject, factory: :subject
    association :teacher, factory: :teacher
  end
end