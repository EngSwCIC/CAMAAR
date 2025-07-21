FactoryBot.define do
  factory :turma do
    semestre { "2025-1" }
    numero_turma { "101" }
    professor { "Prof. Silva" }
    association :materia
  end
end