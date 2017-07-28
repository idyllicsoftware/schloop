FactoryGirl.define do
  factory :bookmark do
    title 'Schloopmark Note'
    data 'Dravid was born in a Marathi family in Indore, Mad...'
    caption 'Schloopmark Note'
    url nil
    preview_image_url nil
    likes 0
    views 0
    topic_id 75
    data_type 0
    school_id 32
    association :grade, factory: :grade
    association :subject, factory: :subject
    association :teacher, factory: :teacher
    reference_bookmark 181
  end
end
