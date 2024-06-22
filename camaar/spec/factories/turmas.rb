FactoryBot.define do
  factory :turma do
    # id { 1 }
    codigo { "TA" }
    semestre { "2021.2" }
    horario { "35T45" }
    materia { association :materia }
  end
end
