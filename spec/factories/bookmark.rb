FactoryGirl.define do
  factory :bookmark do
    title 'Random Title'
    data 'Dravid was born in a Marathi family in Indore, Mad...'
    caption 'Schloopmark Note'
    url nil
    preview_image_url nil
    likes 0
    views 0
    association :topic, factory: :topic
    data_type 0
    school_id 32
    association :grade, factory: :grade
    association :subject, factory: :subject
    association :teacher, factory: :teacher
    reference_bookmark 181
  end
end
