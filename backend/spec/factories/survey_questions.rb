FactoryBot.define do
  factory :survey_question do
    id {1}
    question {"Uma nota de 0 a 10 para a disciplina: "}
    question_number {1}
    optional {false}
    survey_id {1}
    question_type_id {1}
    created_at {"2023-01-30T14:03:40.689Z"}
    updated_at {"2023-01-30T14:03:40.689Z"}
  end
end
