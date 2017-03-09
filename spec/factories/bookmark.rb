FactoryGirl.define do
  factory :bookmark do
    title 'Random Title'
    data 'Dravid was born in a Marathi family in Indore, Mad...'
    caption 'Schloopmark Note'
    url nil
    preview_image_url nil
    likes 0
    views 0
    topic_id 75
    data_type 0
    school_id 32
    grade_id 80
    subject_id 313
    association :teacher, factory: :teacher
    reference_bookmark 181
  end
end
