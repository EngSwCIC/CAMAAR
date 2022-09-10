FactoryBot.define do
  factory :survey_question do
    question { 'Question' }
    optional { false }
    question_type_id { 1 }
  end

end

