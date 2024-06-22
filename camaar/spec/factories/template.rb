FactoryGirl.define do
  factory :template do
    nome "Template de Avaliação"

    association :docente

    transient do
      questoes_count { 3 }
    end

    after(:build) do |template, evaluator|
      template.questaos = build_list(:questao, evaluator.questoes_count, template: template)
    end

    trait :with_questoes do
      after(:create) do |template, evaluator|
        template.questaos = create_list(:questao, evaluator.questoes_count, template: template)
      end
    end
  end
end
