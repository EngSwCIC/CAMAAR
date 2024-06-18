FactoryBot.define do
  factory :template_question do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :template_question1 do
      id { 1 }
      title { 'How are you' }
      question_type { 'text' }
      body { '{"options":{}}' }
      template_id { 1 }
    end

    trait :template_question2 do
      id { 2 }
      title { 'Messi or Cr7?' }
      question_type { 'text' }
      body { '{"options":{}}' }
      template_id { 1 }
    end
  end
end
