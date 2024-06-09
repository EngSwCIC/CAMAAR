FactoryBot.define do
  factory :form_question do
    id {1}
    title {"How are you"}
    question_type {"text"}
    body { [{ question: "Qual seu nível de satisfação?", type: "text" }] }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    form_id {1}
  end
end
