FactoryGirl.define do
  factory :activity do
    teaches 'Thinking & Listening'
    topic 'Early Vocabulary'
    title 'Before the Alphabet: Speak, Speak, Speak & listen'
    master_grade_id 1
    master_subject_id 7
    details '1. Speak with kids as an individual and not as a child.'
    pre_requisite 'None'
    status 'active'
  end
end
