FactoryBot.define do
    factory :formulario do
      association :turma
      association :template
      id_turma { turma.id }
      id_template { template.id }
    end
  end