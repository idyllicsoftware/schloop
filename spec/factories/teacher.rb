require 'pry'
FactoryGirl.define do
  factory :teacher do
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    association :school, factory: :school
    first_name 'Sups'
    middle_name 'dsfsd'
    last_name 'dfd'
    cell_number '5656545412'
  end
end
