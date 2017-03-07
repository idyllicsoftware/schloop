FactoryGirl.define do
  factory :teacher do
    sequence(:email) { |n| "muktesh+#{n}@idyllic.co" }
    association :school, factory: :school
    first_name 'Sups'
    middle_name 'dsfsd'
    last_name 'dfd'
    cell_number '5656545412'
  end
end
