FactoryBot.define do
  factory :form do
    questions { [{ question: "What is your name?", type: "text" }] }
    role { "student" }
    open { false }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    template_id { 1 }
    association :coordinator
    association :subject_class

    trait :form1 do
      questions { [{ question: "What is your name?", type: "text" }] }
      template_id { 1 }
      coordinator
      subject_class
    end

    trait :form2 do
      questions { [{ question: "How old are you?", type: "number" }] }
      template_id { 2 }
      coordinator
      subject_class
    end

    trait :form3 do
      questions { [{ question: "What is your favorite color?", type: "multiple_choice", options: ["Red", "Blue", "Green", "Yellow"] }] }
      template_id { 3 }
      coordinator
      subject_class
    end
  end
end
