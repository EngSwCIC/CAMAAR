FactoryBot.define do
  factory :form do
    id {1}
    questions { [{ question: "Qual seu nível de satisfação?", type: "text" }] }
    open {true}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    template_id {1}
    coordinator_id {1}
    subject_class_id {1}
  end
end
