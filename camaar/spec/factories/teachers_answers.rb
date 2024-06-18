FactoryBot.define do
  factory :teacher_answer do
    answers { ['{"answers":"abcd"}'] }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :teacher_answers1 do
      id { 1 }
      form_question_id { 1 }
      teacher_id { 100 }
    end
  end
end
