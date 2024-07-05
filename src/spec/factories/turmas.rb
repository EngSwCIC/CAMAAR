FactoryBot.define do
    factory :turma do
      classCode { 'A1' }
      semestre { '2024-1' }
      association :professor
      association :materia
    end
  end