FactoryGirl.define do
  factory :collaboration do
    association :bookmark, factory: :bookmark
  end
end
