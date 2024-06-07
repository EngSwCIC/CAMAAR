FactoryBot.define do
  factory :subject_class do
    semester  {"primeiro"}
    subject {"a"}
    code {"b"}
    name {"c"}
    schedule {"d"}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    department_id {1}
    teacher_id {1}
  end
end
