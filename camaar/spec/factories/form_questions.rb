FactoryBot.define do
  factory :form_question do
    body { '{"options":{}}' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :form_question1 do
      id { 1 }
      title { 'How are you' }
      question_type { 'text' }
      form_id { 1 }
    end

    trait :form_question2 do
      id { 2 }
      title { 'How are you' }
      question_type { 'text' }
      form_id { 2 }
    end
  end
end
