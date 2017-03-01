 FactoryGirl.define do
  factory :user_role do
    trait :teacher do
      role_id Role.find_by(name: 'Teacher').id
      entity_type "Teacher"
      association :entity, factory: :teacher
    end
    trait :parent do
      role_id Role.find_by(name: 'Parent').id
      entity_type "Parent"
      association :entity, factory: :parent
    end
    trait :school_admin do
      role_id Role.find_by(name: 'SchoolAdmin').id
      entity_type "SchoolAdmin"
      association :entity, factory: [:user, :school_admin]
    end
    trait :product_admin do
      role_id Role.find_by(name: 'ProductAdmin').id
      entity_type "ProductAdmin"
      association :entity, factory: [:user,:product_admin]
    end
  end
end
