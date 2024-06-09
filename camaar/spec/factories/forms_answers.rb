FactoryBot.define do
  factory :student_answer do
    sequence(:id) { |n| n }
    answers { [{ question: "Satisfatório", type: "text" }] }
    question_type {1}
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    sequence(:form_question_id) { |n| n }
    sequence(:student_id) { |n| n }

    trait :student_answers1 do
      id { 0 }
      form_question_id { 1 }
      student_id { 1 }
    end

    trait :student_answers2 do
      id { 1 }
      form_question_id { 1 }
      student_id { 2 }
    end

    trait :student_answers3 do
      id { 2 }
      form_question_id { 1 }
      student_id { 3 }
    end
  end
end
