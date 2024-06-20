require 'json'
FactoryBot.define do
  factory :student_answer do
    answers { '{"answers":"abcd"}' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

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

    trait :student_answers4 do
      id { 3 }
      form_question_id { 1 }
      student_id { 3 }
    end

    trait :student_answers5 do
      id { 4 }
      form_question_id { 1 }
      student_id { 2 }
    end

    trait :student_answers6 do
      id { 5 }
      form_question_id { 6 }
      student_id { 8 }
      answers { '{"answers":{"1":true,"2":false,"3":false,"4":false,"5":false}}' }
    end
  end
end
