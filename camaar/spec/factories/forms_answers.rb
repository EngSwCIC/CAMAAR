FactoryBot.define do
  factory :student_answer do
    sequence(:id) { |n| n }
    answers { [{ question: "What is your name?", type: "text" }] }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    sequence(:form_id) { |n| n }
    sequence(:student_id) { |n| n }

    trait :student_answers1 do
      id { 0 }
      form_id { 0 }
      student_id { 0 }
    end

    trait :student_answers2 do
      id { 1 }
      form_id { 0 }
      student_id { 1 }
    end

    trait :student_answers3 do
      id { 2 }
      form_id { 0 }
      student_id { 2 }
    end
  end
end
