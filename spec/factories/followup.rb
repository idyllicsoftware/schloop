FactoryGirl.define do
  factory :followup do
    association :bookmark, factory: :bookmark
    boomark_message ''
  end
end