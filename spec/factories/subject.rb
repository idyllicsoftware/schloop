FactoryGirl.define do
  factory :subject do
    name "Physics"
    association :grade, factory: :grade
    association :master_subject, factory: :master_subject, name: "Arts", name_map: "arts"
  end
end
