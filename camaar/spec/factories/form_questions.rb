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

    trait :form_question3 do
      id { 3 }
      title { 'Messi or CR7?' }
      question_type { 'multiple_choice' }
      form_id { 3 }
      # body { '{"options":{"1":"messi","2":"cr7","3":" ","4":" ","5":" "}}' }
      body { '{"options":{"1\":"messi\","2\":"cr7\","3\":"\","4\":"\","5\":"\"}}' }
    end
  end
end
