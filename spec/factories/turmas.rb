# frozen_string_literal: true

FactoryBot.define do
  factory :turma do
    association :disciplina
    association :professor, factory: %i[user professor]
    semestre { '2025.1' }
  end
end
