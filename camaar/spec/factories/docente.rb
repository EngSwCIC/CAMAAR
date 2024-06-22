FactoryGirl.define do
  factory :docente do
    departamento { "Ciência da Computação" }
    association :user

    factory :docente_with_formularios do
      transient do
        formularios_count { 3 }
      end

      after(:create) do |docente, evaluator|
        create_list(:formulario, evaluator.formularios_count, docente: docente)
      end
    end

    factory :docente_with_templates do
      transient do
        templates_count { 2 }
      end

      after(:create) do |docente, evaluator|
        create_list(:template, evaluator.templates_count, docente: docente)
      end
    end

    factory :docente_with_turmas do
      transient do
        classes_count { 4 }
      end

      after(:create) do |docente, evaluator|
        create_list(:turmas, evaluator.classes_count, docente: docente)
      end
    end
  end
end
