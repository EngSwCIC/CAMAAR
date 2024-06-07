FactoryBot.define do
    factory :materia do
      sequence(:codigo) { |n| n }
      sequence(:semestre) { |n| n }
      nome { Faker::Educator.subject }
      horario { Faker::Time.forward(days: 23, period: :morning) }
      association :departamento
      association :professor
      association :aluno
    end
  end
  