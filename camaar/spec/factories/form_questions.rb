FactoryBot.define do
  factory :form_question do
    body { [{ question: 'Qual seu nível de satisfação?', type: 'text' }] }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :form_question1 do
      id { 1 }
      title { 'How are you' }
      question_type { 'text' }
      form_id { 1 }
    end
  end
end
