 FactoryGirl.define do
  factory :user_role do
    trait :teacher do
      role_id 3
      entity_type "Teacher"
      association :entity, factory: :teacher      
    end
    trait :parent do
      role_id 4
      entity_type "Parent"
      association :entity, factory: :parent      
    end
    trait :school_admin do
      role_id 2
      entity_type "SchoolAdmin"
      association :entity, factory: [:user, :school_admin]      
    end
    trait :product_admin do
      role_id 1
      entity_type "ProductAdmin"
      association :entity, factory: [:user,:product_admin]      
    end
  end
end