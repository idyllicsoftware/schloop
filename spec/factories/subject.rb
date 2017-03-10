FactoryGirl.define do
  factory :subject do
    name 'Physics'
    association :grade, factory: :grade
    master_subject_id 3
  end
end
