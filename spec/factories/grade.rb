FactoryGirl.define do
  factory :grade do
    name "Grade I"
    association :school, factory: :school
    association :master_grade, factory: :master_grade
  end
end