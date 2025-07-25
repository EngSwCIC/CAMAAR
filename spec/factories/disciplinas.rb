# frozen_string_literal: true

FactoryBot.define do
  factory :disciplina do
    nome { Faker::Educator.subject }
    codigo { Faker::Alphanumeric.alpha(number: 3).upcase + Faker::Number.number(digits: 3).to_s }
    association :curso
  end
end
