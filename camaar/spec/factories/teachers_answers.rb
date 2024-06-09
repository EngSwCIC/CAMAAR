FactoryBot.define do
  factory :teacher_answer do
    sequence(:id) { |n| n }
    answers { [{ question: "Satisfatório", type: "text" }] }
    question_type {1}
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    sequence(:form_question_id) { |n| n }
    sequence(:teacher_id) { |n| n }

    trait :teacher_answers1 do
      id { 1 }
      form_question_id { 1 }
      teacher_id { 1 }
    end

  end
end
