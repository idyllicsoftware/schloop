FactoryGirl.define do
  factory :division do
    name 'B'
    association :grade, factory: :grade
  end
end