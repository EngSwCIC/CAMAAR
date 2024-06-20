FactoryBot.define do
  factory :materia do
    codigo { 1234 }
    nome { "Teste" }
    association :departamento
    horario { DateTime.new(2024, 6, 20, 9, 0, 0) }
    semestre { Faker::Number.between(from: 1, to: 10) }
  end
end