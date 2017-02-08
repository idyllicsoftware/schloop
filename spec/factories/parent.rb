FactoryGirl.define do
  factory :parent do
    email Faker::Internet.email
    first_name Faker::Name.first_name
    middle_name 'er' 
    last_name "M"
    work_number nil
    cell_number "4555545127"
    association :school, factory: :school
  end
end