FactoryGirl.define do
  factory :activity do
    teaches "Shapes Identification & reasoning "
    topic "Shapes"
    title "2D shape Flashcards"
    master_grade_id 4
    master_subject_id 14
    details "- Introduce the shape with a flashcard. (Introduce..."
    pre_requisite "Shape flashcards, paper, pencil..."
    status 0
  end
end
