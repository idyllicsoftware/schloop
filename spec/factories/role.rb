FactoryGirl.define do
  factory :role do
    trait :product_admin do
      name "ProductAdmin"
      role_map "product-admin"
    end
    trait :school_admin do
      name "SchoolAdmin"
      role_map "school-admin"
    end
    trait :teacher do
      name "Teacher"
      role_map "teacher"
    end
    trait :parent do
      name "Parent"
      role_map "parent"
    end

    status true
  end
end