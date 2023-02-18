FactoryBot.define do
  factory :survey_question do
    question {"Uma nota de 0 a 10 para a disciplina: "}
    question_number {1}
    optional {false}
    survey_id {1}
    question_type_id {1}
  end
end
