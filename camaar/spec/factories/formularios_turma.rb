FactoryGirl.define do
  factory :formularios_turma do
    association :formulario
    association :turma
  end
end
