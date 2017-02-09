 FactoryGirl.define do
  factory :user_role do
    trait :teacher do
      role_id 3
      entity_type "Teacher"
      association :entity, factory: :teacher      
    end
    trait :parent do
      role_id 3
      entity_type "Parent"
      association :entity, factory: :parent      
    end
  end
end