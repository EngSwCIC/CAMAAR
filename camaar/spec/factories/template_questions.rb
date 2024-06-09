FactoryBot.define do
  factory :template_questions do
    id {1}
    title {"How are you"}
    body { [{ question: "Qual seu nível de satisfação?", type: "text" }] }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    template_id {1}
  end
end
