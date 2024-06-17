FactoryBot.define do
  factory :form do
    open { true }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :form1 do
      id { 1 }
      name {"Avaliação Institucional"}
      coordinator_id { 100 }
      subject_class_id { 1 }
    end
  end
end
