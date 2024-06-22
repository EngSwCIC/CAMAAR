FactoryGirl.define do
  factory :turma do
    class_code "TURMA101"
    semestre "2024.1"
    horario  "25T12"
    codigo  "COD123"

    association :disciplina
    association :docente

    factory :turma_with_dicentes do
      transient do
        dicentes_count {3}
      end

      after(:create) do |turma, evaluator|
        create_list(:dicente, evaluator.dicentes_count, turmas: [turma])
      end
    end

    factory :turma_with_formularios do
      transient do
        formularios_count {2}
      end

      after(:create) do |turma, evaluator|
        create_list(:formulario, evaluator.formularios_count, turmas: [turma])
      end
    end
  end
end
