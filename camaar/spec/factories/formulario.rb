FactoryGirl.define do
  factory :formulario do
    nome "Formulário de Avaliação"
    dataDeTermino Date.tomorrow

    association :docente
    association :template

    transient do
      turmas_count { 1 }
    end

    after(:create) do |formulario, evaluator|
      formulario.turmas << create_list(:turma, evaluator.turmas_count)
    end
  end
end
