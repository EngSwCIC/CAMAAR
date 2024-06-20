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
      body { JSON.generate(options: { '1' => 'messi', '2' => 'cr7', '3' => '', '4' => '', '5' => '' }) }
    end

    trait :form_question4 do
      id { 4 }
      title { 'Qual sua materia favorita?' }
      question_type { 'text' }
      form_id { 4 }
    end

    trait :form_question5 do
      id { 5 }
      title { 'Do you love UnB?' }
      question_type { 'text' }
      form_id { 4 }
    end
  end
end
