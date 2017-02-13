FactoryGirl.define do
  master_grade_name = Faker::Lorem.word
  factory :master_grade do
    name master_grade_name.titleize
    name_map master_grade_name.downcase
  end
end