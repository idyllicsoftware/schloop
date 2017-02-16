FactoryGirl.define do
  factory :ecircular do
    title "some title"
    body "some body"
    circular_tag "circular"
    association :created_by, factory: :teacher
    association :school
  end
end
