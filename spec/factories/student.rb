FactoryGirl.define do
  factory :student do
    association :school, factory: :school
    first_name "student_1" 
    last_name "M"
    middle_name 'dfd'
    association :parent, factory: :parent
    activation_status true
  end
end